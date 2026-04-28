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

    // Végösszeg megjelenítése
    updateTotalDisplay();

    // Fizetési módok kezelése
    initPaymentMethods();

    // Fizetés gomb
    document.getElementById('pay').addEventListener('click', processPayment);
});

// Végösszeg frissítése minden szekcióban
function updateTotalDisplay() {
    const total = Cart.getTotal();
    const formattedTotal = total.toLocaleString('hu-HU') + ' Ft';
    
    document.getElementById('card-total').textContent = formattedTotal;
    document.getElementById('paypal-total').textContent = formattedTotal;
    document.getElementById('cash-total').textContent = formattedTotal;
}

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
    
    // Összes szekció elrejtése
    cardSection.style.display = 'none';
    paypalSection.style.display = 'none';
    cashSection.style.display = 'none';
    
    // Megfelelő szekció megjelenítése
    switch(method) {
        case 'card':
            cardSection.style.display = 'block';
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
    payBtn.innerHTML = '<span class="btn-pay-icon">⏳</span> Feldolgozás...';
    alertBox.style.display = 'none';
    
    try {
        // Szállítási cím validálása
        const deliveryAddress = document.getElementById('delivery-address').value.trim();
        if (!deliveryAddress) {
            showAlert('Kérlek add meg a szállítási címet!', 'danger');
            document.getElementById('delivery-address').focus();
            resetPayButton();
            return;
        }

        if (deliveryAddress.length < 5) {
            showAlert('A szállítási cím túl rövid. Kérlek adj meg egy pontos címet!', 'danger');
            document.getElementById('delivery-address').focus();
            resetPayButton();
            return;
        }
        
        // Felhasználó és kosár adatok
        const userId = Session.getUserId();
        const restaurantId = Cart.getRestaurantId();
        const cartItems = Cart.getItems();
        const totalPrice = Cart.getTotal();
        
        if (!userId || !restaurantId || cartItems.length === 0) {
            showAlert('Hiányzó adatok. Kérlek próbáld újra!', 'danger');
            resetPayButton();
            return;
        }
        
        // 1. LÉPÉS: Rendelés létrehozása
        const orderItems = cartItems.map(item => ({
            name: item.name,
            quantity: item.quantity,
            price: item.price
        }));

        const orderResult = await OrdersAPI.create({
            user_id: userId,
            restaurant_id: parseInt(restaurantId),
            delivery_address: deliveryAddress,
            status: 'pending',
            total_price: totalPrice,
            items: orderItems,
            payment_method: currentPaymentMethod
        });
        
        if (!orderResult.success) {
            showAlert('Hiba a rendelés létrehozásakor: ' + (orderResult.data.message || 'Ismeretlen hiba'), 'danger');
            resetPayButton();
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
            resetPayButton();
            return;
        }
        
        // 5. LÉPÉS: Rendelés státuszának frissítése
        await OrdersAPI.update(orderId, {
            status: 'preparing'
        });
        
        // SIKER!
        showAlert('✅ Sikeres rendelés! Rendelésszám: #' + orderId, 'success');
        
        // Kosár ürítése
        Cart.clear();
        
        // Átirányítás 3 mp után
        setTimeout(() => {
            window.location.href = 'profile.html';
        }, 3000);
        
    } catch (error) {
        console.error('Fizetési hiba:', error);
        showAlert('Hálózati hiba történt. Próbáld újra később!', 'danger');
        resetPayButton();
    }
}

// Pay gomb visszaállítása
function resetPayButton() {
    const payBtn = document.getElementById('pay');
    payBtn.disabled = false;
    payBtn.innerHTML = '<span class="btn-pay-icon">🛒</span> Rendelés leadása';
}

// Alert megjelenítése
function showAlert(message, type) {
    const alertBox = document.getElementById('alert-box');
    alertBox.className = `alert-box alert-${type}`;
    alertBox.textContent = message;
    alertBox.style.display = 'block';
    
    if (type !== 'success') {
        setTimeout(() => {
            alertBox.style.display = 'none';
        }, 5000);
    }
}

console.log('Payment.js betöltve');
