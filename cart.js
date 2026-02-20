/**
 * KLSZ Faloda - Kosár oldal JavaScript
 */

document.addEventListener('DOMContentLoaded', function() {
    loadCart();
    updateNavigation();
});

// Kosár betöltése és megjelenítése
function loadCart() {
    const cartItems = Cart.getItems();
    const cartTableBody = document.getElementById('cartItems');
    const cartSummary = document.getElementById('cartSummary');
    const cartButtons = document.getElementById('cartButtons');
    const restaurantInfo = document.getElementById('restaurantInfo');
    const restaurantName = document.getElementById('restaurantName');
    const totalPriceElement = document.getElementById('totalPrice');

    if (cartItems.length === 0) {
        // Üres kosár
        cartTableBody.innerHTML = `
            <tr>
                <td colspan="5" class="empty-cart-message">
                    A kosár üres
                </td>
            </tr>
        `;
        cartSummary.style.display = 'none';
        cartButtons.style.display = 'none';
        restaurantInfo.style.display = 'none';
    } else {
        // Kosár tartalma
        let html = '';
        
        cartItems.forEach(item => {
            const itemTotal = item.price * item.quantity;
            html += `
                <tr data-dish-id="${item.dish_id}">
                    <td>${item.name}</td>
                    <td>
                        <div class="quantity-controls">
                            <button class="btn btn-sm btn-outline-warning" onclick="changeQuantity(${item.dish_id}, -1)">-</button>
                            <span class="mx-2">${item.quantity}</span>
                            <button class="btn btn-sm btn-outline-warning" onclick="changeQuantity(${item.dish_id}, 1)">+</button>
                        </div>
                    </td>
                    <td>${formatPrice(item.price)}</td>
                    <td>
                        <button class="btn btn-sm btn-danger" onclick="removeFromCart(${item.dish_id})">Törlés</button>
                    </td>
                </tr>
            `;
        });

        cartTableBody.innerHTML = html;

        // Összesítés megjelenítése
        const total = Cart.getTotal();
        totalPriceElement.textContent = formatPrice(total);
        cartSummary.style.display = 'block';
        cartButtons.style.display = 'flex';

        // Étterem info megjelenítése
        const restName = Cart.getRestaurantName();
        if (restName) {
            restaurantName.textContent = restName;
            restaurantInfo.style.display = 'block';
        }
    }
}

// Mennyiség változtatása
function changeQuantity(dishId, change) {
    const cartItems = Cart.getItems();
    const item = cartItems.find(i => i.dish_id === dishId);
    
    if (item) {
        const newQuantity = item.quantity + change;
        Cart.updateQuantity(dishId, newQuantity);
        loadCart();
    }
}

// Tétel eltávolítása a kosárból
function removeFromCart(dishId) {
    Cart.removeItem(dishId);
    loadCart();
}

// Kosár ürítése és újratöltés
function clearCartAndRefresh() {
    if (confirm('Biztosan törölni szeretnéd a kosár tartalmát?')) {
        Cart.clear();
        loadCart();
    }
}

// Fizetéshez továbblépés
function goToCheckout() {
    // Bejelentkezés ellenőrzése
    if (!Session.isLoggedIn()) {
        alert('A fizetéshez be kell jelentkezned!');
        window.location.href = 'login.html';
        return;
    }

    const cartItems = Cart.getItems();
    if (cartItems.length === 0) {
        alert('A kosarad üres!');
        return;
    }

    // Átirányítás a fizetés oldalra
    window.location.href = 'payment-final.html';
}

console.log('Cart.js betöltve');
