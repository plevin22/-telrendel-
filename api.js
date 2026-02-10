const API_BASE_URL = 'http://localhost:8080/vizsgaremek1/webresources';

// API Végpontok
const API_ENDPOINTS = {
    // Users
    users: {
        getAll: `${API_BASE_URL}/users/GetAllUsers`,
        getById: (id) => `${API_BASE_URL}/users/GetUserById/${id}`,
        create: `${API_BASE_URL}/users/CreateUser`,
        login: `${API_BASE_URL}/users/Login`,
        update: (id) => `${API_BASE_URL}/users/UpdateUser/${id}`,
        delete: (id) => `${API_BASE_URL}/users/DeleteUser/${id}`
    },
    // Dishes
    dishes: {
        getAll: `${API_BASE_URL}/dishes/GetAllDishes`,
        getById: (id) => `${API_BASE_URL}/dishes/GetDishById/${id}`,
        getByRestaurant: (id) => `${API_BASE_URL}/dishes/GetDishesByRestaurant/${id}`,
        add: `${API_BASE_URL}/dishes/AddDish`,
        update: (id) => `${API_BASE_URL}/dishes/UpdateDish/${id}`,
        delete: (id) => `${API_BASE_URL}/dishes/DeleteDish/${id}`
    },
    // Orders
    orders: {
        getAll: `${API_BASE_URL}/orders/GetAllOrders`,
        getById: (id) => `${API_BASE_URL}/orders/GetOrderById/${id}`,
        getByUser: (userId) => `${API_BASE_URL}/orders/GetOrdersByUser/${userId}`,
        add: `${API_BASE_URL}/orders/AddOrder`,
        update: (id) => `${API_BASE_URL}/orders/UpdateOrder/${id}`,
        delete: (id) => `${API_BASE_URL}/orders/DeleteOrder/${id}`
    },
    // Order Items
    orderItems: {
        getAll: `${API_BASE_URL}/orderitems/GetAllOrderItems`,
        getById: (id) => `${API_BASE_URL}/orderitems/GetOrderItemById/${id}`,
        getByOrder: (orderId) => `${API_BASE_URL}/orderitems/GetOrderItemsByOrder/${orderId}`,
        add: `${API_BASE_URL}/orderitems/AddOrderItem`,
        update: (id) => `${API_BASE_URL}/orderitems/UpdateOrderItem/${id}`,
        delete: (id) => `${API_BASE_URL}/orderitems/DeleteOrderItem/${id}`
    },
    // Payments
    payments: {
        getAll: `${API_BASE_URL}/payments/GetAllPayments`,
        getById: (id) => `${API_BASE_URL}/payments/GetPaymentById/${id}`,
        getByOrder: (orderId) => `${API_BASE_URL}/payments/GetPaymentByOrder/${orderId}`,
        add: `${API_BASE_URL}/payments/AddPayment`,
        update: (id) => `${API_BASE_URL}/payments/UpdatePayment/${id}`,
        delete: (id) => `${API_BASE_URL}/payments/DeletePayment/${id}`
    }
};

//api call
async function apiCall(url, method = 'GET', data = null) {
    const options = {
        method: method,
        headers: {
            'Content-Type': 'application/json'
        }
    };

    if (data && (method === 'POST' || method === 'PUT')) {
        options.body = JSON.stringify(data);
    }

    try {
        const response = await fetch(url, options);
        const responseData = await response.json();
        
        return {
            success: response.ok,
            status: response.status,
            data: responseData
        };
    } catch (error) {
        console.error('API hiba:', error);
        return {
            success: false,
            status: 0,
            data: { message: 'Hálózati hiba. Ellenőrizd, hogy a szerver fut-e!' }
        };
    }
}

//user api függvények
const UserAPI = {
    // Bejelentkezés
    async login(email, password) {
        return await apiCall(API_ENDPOINTS.users.login, 'POST', { email, password });
    },

    // Regisztráció
    async register(userData) {
        return await apiCall(API_ENDPOINTS.users.create, 'POST', userData);
    },

    // Felhasználó lekérése ID alapján
    async getById(id) {
        return await apiCall(API_ENDPOINTS.users.getById(id));
    },

    // Összes felhasználó lekérése
    async getAll() {
        return await apiCall(API_ENDPOINTS.users.getAll);
    },

    // Felhasználó frissítése
    async update(id, userData) {
        return await apiCall(API_ENDPOINTS.users.update(id), 'PUT', userData);
    },

    // Felhasználó törlése
    async delete(id) {
        return await apiCall(API_ENDPOINTS.users.delete(id), 'DELETE');
    }
};

//dishes api függvények
const DishesAPI = {
    // Összes étel lekérése
    async getAll() {
        return await apiCall(API_ENDPOINTS.dishes.getAll);
    },

    // Étel lekérése ID alapján
    async getById(id) {
        return await apiCall(API_ENDPOINTS.dishes.getById(id));
    },

    // Ételek lekérése étterem alapján
    async getByRestaurant(restaurantId) {
        return await apiCall(API_ENDPOINTS.dishes.getByRestaurant(restaurantId));
    },

    // Étel hozzáadása
    async add(dishData) {
        return await apiCall(API_ENDPOINTS.dishes.add, 'POST', dishData);
    },

    // Étel frissítése
    async update(id, dishData) {
        return await apiCall(API_ENDPOINTS.dishes.update(id), 'PUT', dishData);
    },

    // Étel törlése
    async delete(id) {
        return await apiCall(API_ENDPOINTS.dishes.delete(id), 'DELETE');
    }
};

// orders api függvények
const OrdersAPI = {
    // Összes rendelés
    async getAll() {
        return await apiCall(API_ENDPOINTS.orders.getAll);
    },

    // Rendelés lekérése ID alapján
    async getById(id) {
        return await apiCall(API_ENDPOINTS.orders.getById(id));
    },

    // Felhasználó rendelései
    async getByUser(userId) {
        return await apiCall(API_ENDPOINTS.orders.getByUser(userId));
    },

    // Rendelés létrehozása
    async create(orderData) {
        return await apiCall(API_ENDPOINTS.orders.add, 'POST', orderData);
    },

    // Rendelés frissítése
    async update(id, orderData) {
        return await apiCall(API_ENDPOINTS.orders.update(id), 'PUT', orderData);
    },

    // Rendelés törlése
    async delete(id) {
        return await apiCall(API_ENDPOINTS.orders.delete(id), 'DELETE');
    }
};
//order item api függvények
const OrderItemsAPI = {
    // Összes rendelési tétel
    async getAll() {
        return await apiCall(API_ENDPOINTS.orderItems.getAll);
    },

    // Tétel lekérése ID alapján
    async getById(id) {
        return await apiCall(API_ENDPOINTS.orderItems.getById(id));
    },

    // Rendelés tételeinek lekérése
    async getByOrder(orderId) {
        return await apiCall(API_ENDPOINTS.orderItems.getByOrder(orderId));
    },

    // Tétel hozzáadása
    async add(itemData) {
        return await apiCall(API_ENDPOINTS.orderItems.add, 'POST', itemData);
    },

    // Tétel frissítése
    async update(id, itemData) {
        return await apiCall(API_ENDPOINTS.orderItems.update(id), 'PUT', itemData);
    },

    // Tétel törlése
    async delete(id) {
        return await apiCall(API_ENDPOINTS.orderItems.delete(id), 'DELETE');
    }
};

//payments api függvények
const PaymentsAPI = {
    // Összes fizetés
    async getAll() {
        return await apiCall(API_ENDPOINTS.payments.getAll);
    },

    // Fizetés lekérése ID alapján
    async getById(id) {
        return await apiCall(API_ENDPOINTS.payments.getById(id));
    },

    // Rendeléshez tartozó fizetés
    async getByOrder(orderId) {
        return await apiCall(API_ENDPOINTS.payments.getByOrder(orderId));
    },

    // Fizetés létrehozása
    async create(paymentData) {
        return await apiCall(API_ENDPOINTS.payments.add, 'POST', paymentData);
    },

    // Fizetés frissítése
    async update(id, paymentData) {
        return await apiCall(API_ENDPOINTS.payments.update(id), 'PUT', paymentData);
    },

    // Fizetés törlése
    async delete(id) {
        return await apiCall(API_ENDPOINTS.payments.delete(id), 'DELETE');
    }
};

//session kezelés 
const Session = {
    // Felhasználó bejelentkeztetése
    login(userData) {
        localStorage.setItem('user', JSON.stringify(userData));
        localStorage.setItem('isLoggedIn', 'true');
    },

    // Kijelentkezés
    logout() {
        localStorage.removeItem('user');
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('cart');
        localStorage.removeItem('restaurantId');
        localStorage.removeItem('restaurantName');
    },

    // Bejelentkezett felhasználó lekérése
    getUser() {
        const user = localStorage.getItem('user');
        return user ? JSON.parse(user) : null;
    },

    // Bejelentkezve van-e
    isLoggedIn() {
        return localStorage.getItem('isLoggedIn') === 'true';
    },

    // Felhasználó ID lekérése
    getUserId() {
        const user = this.getUser();
        return user ? user.user_id : null;
    },

    // Felhasználó szerepkörének lekérése
    getUserRole() {
        const user = this.getUser();
        return user ? user.role : null;
    }
};

//kosár kezelés
const Cart = {
    // Kosár lekérése
    getItems() {
        const cart = localStorage.getItem('cart');
        return cart ? JSON.parse(cart) : [];
    },

    // Tétel hozzáadása
    addItem(item) {
        const cart = this.getItems();
        const existingIndex = cart.findIndex(i => i.dish_id === item.dish_id);
        
        if (existingIndex > -1) {
            cart[existingIndex].quantity += item.quantity || 1;
        } else {
            cart.push({
                dish_id: item.dish_id,
                name: item.name,
                price: item.price,
                quantity: item.quantity || 1,
                restaurant_id: item.restaurant_id
            });
        }
        
        localStorage.setItem('cart', JSON.stringify(cart));
        this.updateCartDisplay();
    },

    // Tétel eltávolítása
    removeItem(dishId) {
        let cart = this.getItems();
        cart = cart.filter(item => item.dish_id !== dishId);
        localStorage.setItem('cart', JSON.stringify(cart));
        this.updateCartDisplay();
    },

    // Mennyiség frissítése
    updateQuantity(dishId, quantity) {
        const cart = this.getItems();
        const item = cart.find(i => i.dish_id === dishId);
        if (item) {
            item.quantity = quantity;
            if (quantity <= 0) {
                this.removeItem(dishId);
            } else {
                localStorage.setItem('cart', JSON.stringify(cart));
                this.updateCartDisplay();
            }
        }
    },

    // Kosár ürítése
    clear() {
        localStorage.removeItem('cart');
        localStorage.removeItem('restaurantId');
        localStorage.removeItem('restaurantName');
        this.updateCartDisplay();
    },

    // Végösszeg számítása
    getTotal() {
        const cart = this.getItems();
        return cart.reduce((total, item) => total + (item.price * item.quantity), 0);
    },

    // Tételek száma
    getItemCount() {
        const cart = this.getItems();
        return cart.reduce((count, item) => count + item.quantity, 0);
    },

    // Étterem ID lekérése
    getRestaurantId() {
        return localStorage.getItem('restaurantId');
    },

    // Étterem ID beállítása
    setRestaurantId(id) {
        localStorage.setItem('restaurantId', id);
    },

    // Étterem név beállítása
    setRestaurantName(name) {
        localStorage.setItem('restaurantName', name);
    },

    // Étterem név lekérése
    getRestaurantName() {
        return localStorage.getItem('restaurantName');
    },

    // Kosár megjelenítés frissítése (ha van sidebar)
    updateCartDisplay() {
        const cartTotal = document.querySelector('.cart-total');
        if (cartTotal) {
            cartTotal.textContent = this.getTotal().toLocaleString('hu-HU') + ' Ft';
        }
    }
};

//Segés függvények:

// Üzenet megjelenítése
function showMessage(elementId, message, isError = false) {
    const element = document.getElementById(elementId);
    if (element) {
        element.textContent = message;
        element.style.display = 'block';
        element.className = isError ? 'alert alert-danger' : 'alert alert-success';
        
        // 5 másodperc után eltűnik
        setTimeout(() => {
            element.style.display = 'none';
        }, 5000);
    }
}

// Ár formázása
function formatPrice(price) {
    return Number(price).toLocaleString('hu-HU') + ' Ft';
}

// Dátum formázása
function formatDate(dateString) {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleString('hu-HU');
}

// Státusz magyarra fordítása
function translateStatus(status) {
    const statusMap = {
        'pending': 'Függőben',
        'preparing': 'Készítés alatt',
        'delivering': 'Kiszállítás alatt',
        'completed': 'Teljesítve',
        'cancelled': 'Lemondva',
        'paid': 'Fizetve',
        'failed': 'Sikertelen'
    };
    return statusMap[status] || status;
}

// Szerepkör magyarra fordítása
function translateRole(role) {
    const roleMap = {
        'customer': 'Vásárló',
        'admin': 'Admin',
        'restaurant_owner': 'Étterem tulajdonos'
    };
    return roleMap[role] || role;
}

// Navigációs menü frissítése bejelentkezés alapján
function updateNavigation() {
    const navbarNav = document.querySelector('#navbarNav .navbar-nav');
    if (!navbarNav) return;

    if (Session.isLoggedIn()) {
        const user = Session.getUser();
        // Bejelentkezett állapot
        navbarNav.innerHTML = `
            <li class="nav-item">
                <a class="nav-link" href="index.html">Főoldal</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="restaurants.html">Éttermek</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="profile.html">Profilom (${user.name})</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="cart.html">Kosár</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#" onclick="logoutUser()">Kijelentkezés</a>
            </li>
        `;
        
        // Admin menüpont hozzáadása ha admin
        if (user.role === 'admin') {
            const adminItem = document.createElement('li');
            adminItem.className = 'nav-item';
            adminItem.innerHTML = '<a class="nav-link" href="admin-dashboard.html">Admin</a>';
            navbarNav.insertBefore(adminItem, navbarNav.lastElementChild);
        }
    } else {
        // Kijelentkezett állapot
        navbarNav.innerHTML = `
            <li class="nav-item">
                <a class="nav-link" href="index.html">Főoldal</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="restaurants.html">Éttermek</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="login.html">Bejelentkezés</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="registration.html">Regisztráció</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="cart.html">Kosár</a>
            </li>
        `;
    }
}

// Kijelentkezés függvény
function logoutUser() {
    Session.logout();
    window.location.href = 'index.html';
}

// Oldal betöltésekor navigáció frissítése
document.addEventListener('DOMContentLoaded', function() {
    updateNavigation();
});

console.log('API.js betöltve - Backend URL:', API_BASE_URL);
