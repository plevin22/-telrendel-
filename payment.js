/**
 * KLSZ Faloda - Fizetés oldal JavaScript
 * Backend integráció: rendelés létrehozása, fizetés feldolgozása
 */

// Aktuális fizetési mód
let currentPaymentMethod = 'card';

document.addEventListener('DOMContentLoaded', function() {
    // Bejelentkezés ellenőrzése
    if (!Session.isLoggedIn()) {
        alert('A fizetéshez be kell jelentkezned!');
        window.location.href = 'login.html';
        return;
    }

    // Kosár ellenőrzése
    const cartItems = Cart.getItems();
    if (cartItems.length === 0) {
        alert('A kosarad üres!');
        window.location.href = 'cart.html';
        return;
    }

    // Navigáció frissítése
    updateNavigation();

    // Fizetési módok kezelése
    initPaymentMethods();

    // Fizetés gomb
    document.getElementById('pay').addEventListener('click', processPayment);
});

// Fizetési módok inicializálása
function initPaymentMethods() {
    const pmButtons = document.querySelectorAll('.pm-btn');
    
    pmButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            // Aktív osztály eltávolítása
            pmButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            
            // Fizetési mód beállítása
            const method = this.getAttribute('data-method');
            currentPaymentMethod = method;
            
            // Szekciók megjelenítése/elrejtése
            updatePaymentSections(method);
        });
    });
}

// Fizetési szekciók frissítése
function updatePaymentSections(method) {
    const cardSection = document.getElementById('card-section');
    const paypalSection = document.getElementById('paypal-section');
    const cashSection = document.getElementById('cash-section');
    const cardFront = document.getElementById('card-front');
    const cardBack = document.getElementById('card-back');
    
    // Összes szekció elrejtése
    cardSection.style.display = 'none';
    paypalSection.style.display = 'none';
    cashSection.style.display = 'none';
    
    // Megfelelő szekció megjelenítése
    switch(method) {
        case 'visa':
        case 'mastercard':
            cardSection.style.display = 'block';
            // Kártya típus frissítése
            cardFront.className = 'card-face card-front ' + method;
            cardBack.className = 'card-face card-back ' + method;
            
            if (method === 'visa') {
                document.getElementById('visa-logo').style.display = 'block';
                document.getElementById('mastercard-logo').style.display = 'none';
            } else {
                document.getElementById('visa-logo').style.display = 'none';
                document.getElementById('mastercard-logo').style.display = 'flex';
            }
            currentPaymentMethod = 'card';
            break;
        case 'paypal':
            paypalSection.style.display = 'block';
            currentPaymentMethod = 'paypal';
            break;
        case 'cash':
            cashSection.style.display = 'block';
            currentPaymentMethod = 'cash';
            break;
    }
}

// Fizetés feldolgozása
async function processPayment() {
    const payBtn = document.getElementById('pay');
    const alertBox = document.getElementById('alert-box');
    
    // Gomb letiltása
    payBtn.disabled = true;
    payBtn.textContent = 'Feldolgozás...';
    alertBox.style.display = 'none';
    
    try {
        // Szállítási cím validálása
        const deliveryAddress = document.getElementById('delivery-address').value.trim();
        if (!deliveryAddress) {
            showAlert('Kérlek add meg a szállítási címet!', 'danger');
            document.getElementById('delivery-address').focus();
            payBtn.disabled = false;
            payBtn.textContent = 'Fizetés véglegesítése';
            return;
        }

        if (deliveryAddress.length < 5) {
            showAlert('A szállítási cím túl rövid. Kérlek adj meg egy pontos címet!', 'danger');
            document.getElementById('delivery-address').focus();
            payBtn.disabled = false;
            payBtn.textContent = 'Fizetés véglegesítése';
            return;
        }

        // Kártyás fizetés esetén validáció
        if (currentPaymentMethod === 'card') {
            if (!validateCardData()) {
                payBtn.disabled = false;
                payBtn.textContent = 'Fizetés véglegesítése';
                return;
            }
        }
        
        // Felhasználó és kosár adatok
        const userId = Session.getUserId();
        const restaurantId = Cart.getRestaurantId();
        const cartItems = Cart.getItems();
        const totalPrice = Cart.getTotal();
        
        if (!userId || !restaurantId || cartItems.length === 0) {
            showAlert('Hiányzó adatok. Kérlek próbáld újra!', 'danger');
            payBtn.disabled = false;
            payBtn.textContent = 'Fizetés véglegesítése';
            return;
        }
        
        // 1. LÉPÉS: Rendelés létrehozása (szállítási címmel!)
        const orderResult = await OrdersAPI.create({
            user_id: userId,
            restaurant_id: parseInt(restaurantId),
            delivery_address: deliveryAddress,
            status: 'pending',
            total_price: totalPrice
        });
        
        if (!orderResult.success) {
            showAlert('Hiba a rendelés létrehozásakor: ' + (orderResult.data.message || 'Ismeretlen hiba'), 'danger');
            payBtn.disabled = false;
            payBtn.textContent = 'Fizetés véglegesítése';
            return;
        }
        
        const orderId = orderResult.data.order_id;
        console.log('Rendelés létrehozva, ID:', orderId);
        
        // 2. LÉPÉS: Rendelési tételek hozzáadása
        for (const item of cartItems) {
            const itemResult = await OrderItemsAPI.add({
                order_id: orderId,
                dish_id: item.dish_id,
                quantity: item.quantity
            });
            
            if (!itemResult.success) {
                console.error('Hiba tétel hozzáadásakor:', item.name, itemResult.data);
            }
        }
        
        // 3. LÉPÉS: Rendelés végösszegének frissítése
        await OrdersAPI.update(orderId, {
            status: 'pending',
            total_price: totalPrice
        });
        
        // 4. LÉPÉS: Fizetés létrehozása
        const paymentResult = await PaymentsAPI.create({
            order_id: orderId,
            method: currentPaymentMethod,
            status: currentPaymentMethod === 'cash' ? 'pending' : 'paid'
        });
        
        if (!paymentResult.success) {
            showAlert('Hiba a fizetés feldolgozásakor: ' + (paymentResult.data.message || 'Ismeretlen hiba'), 'danger');
            payBtn.disabled = false;
            payBtn.textContent = 'Fizetés véglegesítése';
            return;
        }
        
        // 5. LÉPÉS: Rendelés státuszának frissítése
        await OrdersAPI.update(orderId, {
            status: 'preparing'
        });
        
        // SIKER!
        showAlert('Sikeres rendelés! Rendelésszám: #' + orderId + ' | Szállítási cím: ' + deliveryAddress, 'success');
        
        // Kosár ürítése
        Cart.clear();
        
        // Átirányítás 3 mp után
        setTimeout(() => {
            window.location.href = 'profile.html';
        }, 3000);
        
    } catch (error) {
        console.error('Fizetési hiba:', error);
        showAlert('Hálózati hiba történt. Próbáld újra később!', 'danger');
        payBtn.disabled = false;
        payBtn.textContent = 'Fizetés véglegesítése';
    }
}

// Kártya adatok validálása
function validateCardData() {
    const cardNumber = document.getElementById('card-number').value.replace(/\s/g, '');
    const cardName = document.getElementById('card-name').value.trim();
    const cardExpiry = document.getElementById('card-expiry').value.trim();
    const cardCvc = document.getElementById('card-cvc').value.trim();
    
    if (!cardNumber || cardNumber.length < 16) {
        showAlert('Kérlek add meg a helyes kártyaszámot!', 'danger');
        return false;
    }
    
    if (!cardName) {
        showAlert('Kérlek add meg a kártyabirtokos nevét!', 'danger');
        return false;
    }
    
    if (!cardExpiry || !/^\d{2}\/\d{2}$/.test(cardExpiry)) {
        showAlert('Kérlek add meg a helyes lejárati dátumot (MM/YY)!', 'danger');
        return false;
    }
    
    if (!cardCvc || cardCvc.length < 3) {
        showAlert('Kérlek add meg a CVC kódot!', 'danger');
        return false;
    }
    
    return true;
}

// Alert megjelenítése
function showAlert(message, type) {
    const alertBox = document.getElementById('alert-box');
    alertBox.className = `alert alert-${type}`;
    alertBox.textContent = message;
    alertBox.style.display = 'block';
    
    if (type === 'success') {
        // Sikeres üzenetnél nem tűnik el
    } else {
        setTimeout(() => {
            alertBox.style.display = 'none';
        }, 5000);
    }
}

console.log('Payment.js betöltve');