document.addEventListener('DOMContentLoaded', function() {
    loadCart();
    updateNavigation();
});

// Kosár betöltése és megjelenítése
function loadCart() {
    const cartItems = Cart.getItems();
    const cartItemsContainer = document.getElementById('cartItems');
    const cartSummary = document.getElementById('cartSummary');
    const emptyCart = document.getElementById('emptyCart');
    const restaurantInfo = document.getElementById('restaurantInfo');
    const restaurantName = document.getElementById('restaurantName');

    if (cartItems.length === 0) {
        // Üres kosár
        cartItemsContainer.innerHTML = '';
        cartSummary.style.display = 'none';
        emptyCart.style.display = 'block';
        restaurantInfo.style.display = 'none';
    } else {
        // Kosár tartalma
        emptyCart.style.display = 'none';
        cartSummary.style.display = 'block';

        let html = '';
        
        cartItems.forEach(item => {
            const itemTotal = item.price * item.quantity;
            const imageHtml = item.image_url 
                ? `<img src="${item.image_url}" alt="${item.name}" onerror="this.parentElement.innerHTML='<div class=\\'no-image\\'>🍽️</div>'">`
                : `<div class="no-image">🍽️</div>`;
            
            html += `
                <div class="cart-item" data-dish-id="${item.dish_id}">
                    <div class="item-image">
                        ${imageHtml}
                    </div>
                    <div class="item-details">
                        <div class="item-name">${item.name}</div>
                        <div class="item-price">${formatPrice(item.price)} / db</div>
                    </div>
                    <div class="item-controls">
                        <div class="quantity-controls">
                            <button class="btn-qty" onclick="changeQuantity(${item.dish_id}, -1)">−</button>
                            <span class="qty-value">${item.quantity}</span>
                            <button class="btn-qty" onclick="changeQuantity(${item.dish_id}, 1)">+</button>
                        </div>
                        <div class="item-total">
                            <div class="item-total-label">Összesen</div>
                            <div class="item-total-value">${formatPrice(itemTotal)}</div>
                        </div>
                        <button class="btn-remove" onclick="removeFromCart(${item.dish_id})" title="Törlés">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                                <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/>
                                <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"/>
                            </svg>
                        </button>
                    </div>
                </div>
            `;
        });

        cartItemsContainer.innerHTML = html;

        // Összesítés
        const total = Cart.getTotal();
        document.getElementById('subtotalPrice').textContent = formatPrice(total);
        document.getElementById('totalPrice').textContent = formatPrice(total);

        // Étterem info
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
