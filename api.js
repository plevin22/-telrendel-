const API_BASE_URL = 'http://localhost:8080/vizsgaremek1/webresources';

// API Végpontok
const API_ENDPOINTS = {
    // Restaurants
    restaurants: {
        getAll: `${API_BASE_URL}/restaurants/GetAllRestaurants`,
        getById: (id) => `${API_BASE_URL}/restaurants/GetRestaurantById/${id}`,
        add: `${API_BASE_URL}/restaurants/AddRestaurant`,
        update: (id) => `${API_BASE_URL}/restaurants/UpdateRestaurant/${id}`,
        delete: (id) => `${API_BASE_URL}/restaurants/DeleteRestaurant/${id}`
    },
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
    },
    // Reviews
    reviews: {
        add: `${API_BASE_URL}/reviews/AddReview`,
        getById: (id) => `${API_BASE_URL}/reviews/GetReviewById/${id}`,
        getByRestaurant: (id) => `${API_BASE_URL}/reviews/GetReviewsByRestaurant/${id}`,
        getByUser: (id) => `${API_BASE_URL}/reviews/GetReviewsByUser/${id}`,
        getAverage: (id) => `${API_BASE_URL}/reviews/GetAverageRating/${id}`,
        getRecent: (limit) => `${API_BASE_URL}/reviews/GetRecentReviews/${limit}`,
        update: (id) => `${API_BASE_URL}/reviews/UpdateReview/${id}`,
        delete: (id) => `${API_BASE_URL}/reviews/DeleteReview/${id}`,
        search: (keyword) => `${API_BASE_URL}/reviews/SearchByComment/${keyword}`
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

// Restaurants API függvények
const RestaurantsAPI = {
    // Összes étterem lekérése
    async getAll() {
        return await apiCall(API_ENDPOINTS.restaurants.getAll);
    },

    // Étterem lekérése ID alapján
    async getById(id) {
        return await apiCall(API_ENDPOINTS.restaurants.getById(id));
    },

    // Étterem hozzáadása
    async add(restaurantData) {
        return await apiCall(API_ENDPOINTS.restaurants.add, 'POST', restaurantData);
    },

    // Étterem frissítése
    async update(id, restaurantData) {
        return await apiCall(API_ENDPOINTS.restaurants.update(id), 'PUT', restaurantData);
    },

    // Étterem törlése
    async delete(id) {
        return await apiCall(API_ENDPOINTS.restaurants.delete(id), 'DELETE');
    }
};

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

// Reviews API függvények
const ReviewsAPI = {
    // Értékelés hozzáadása
    async add(reviewData) {
        return await apiCall(API_ENDPOINTS.reviews.add, 'POST', reviewData);
    },

    // Értékelés lekérése ID alapján
    async getById(id) {
        return await apiCall(API_ENDPOINTS.reviews.getById(id));
    },

    // Étterem értékelései
    async getByRestaurant(restaurantId) {
        return await apiCall(API_ENDPOINTS.reviews.getByRestaurant(restaurantId));
    },

    // Felhasználó értékelései
    async getByUser(userId) {
        return await apiCall(API_ENDPOINTS.reviews.getByUser(userId));
    },

    // Átlagos értékelés
    async getAverage(restaurantId) {
        return await apiCall(API_ENDPOINTS.reviews.getAverage(restaurantId));
    },

    // Legutóbbi értékelések
    async getRecent(limit) {
        return await apiCall(API_ENDPOINTS.reviews.getRecent(limit));
    },

    // Értékelés frissítése
    async update(id, reviewData) {
        return await apiCall(API_ENDPOINTS.reviews.update(id), 'PUT', reviewData);
    },

    // Értékelés törlése
    async delete(id) {
        return await apiCall(API_ENDPOINTS.reviews.delete(id), 'DELETE');
    },

    // Keresés komment alapján
    async search(keyword) {
        return await apiCall(API_ENDPOINTS.reviews.search(keyword));
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
                        <a class="nav-link" href="index.html">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="me-1" viewBox="0 0 16 16"><path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4z"/></svg>
                            Főoldal
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="restaurants.html">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="me-1" viewBox="0 0 16 16"><path d="M7 4.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm-6 3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm-3 3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zM4 4.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zM2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2zm2-1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H4z"/></svg>
                            Éttermek
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="profile.html">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="me-1" viewBox="0 0 16 16"><path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/></svg>
                            Fiók
                        </a>
                    </li>
                    
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="logoutUser()">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0v2z"/>
                                <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
                            </svg>
                            Kijelentkezés
                        </a>
                    </li>
                    <li class="nav-item ms-lg-2">
                        <a class="nav-link nav-cart-btn" href="cart.html">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="me-1" viewBox="0 0 16 16"><path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5M3.102 4l1.313 7h8.17l1.313-7zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4m7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4m-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2m7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2"/></svg>
                            Kosár
                        </a>
                    </li>
                <li/>
        `;
        /**/
        // Admin menüpont hozzáadása ha admin vagy restaurant_owner
        if (user.role === 'admin' || user.role === 'restaurant_owner') {
            const adminItem = document.createElement('li');
            adminItem.className = 'nav-item';
            adminItem.innerHTML = '<a class="nav-link" href="admin-dashboard.html">Admin</a>';
            navbarNav.insertBefore(adminItem, navbarNav.lastElementChild);
        }
    } else {
        // Kijelentkezett állapot
        navbarNav.innerHTML = `
<li class="nav-item">
    <a class="nav-link" href="index.html">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
            <path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4z"/>
        </svg>
        Főoldal
    </a>
</li>
<li class="nav-item">
    <a class="nav-link" href="restaurants.html">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
            <path d="M7 4.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm-6 3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zm-3 3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zM4 4.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5v-1zM2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2zm2-1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H4z"/>
        </svg>
        Éttermek
    </a>
</li>
<li class="nav-item">
    <a class="nav-link" href="login.html">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
            <path fill-rule="evenodd" d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0z"/>
            <path fill-rule="evenodd" d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
        </svg>
        Bejelentkezés
    </a>
</li>
<li class="nav-item">
    <a class="nav-link" href="registration.html">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
            <path d="M12.5 16a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7m.5-5v1h1a.5.5 0 0 1 0 1h-1v1a.5.5 0 0 1-1 0v-1h-1a.5.5 0 0 1 0-1h1v-1a.5.5 0 0 1 1 0m-2-6a3 3 0 1 1-6 0 3 3 0 0 1 6 0M8 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4"/>
            <path d="M8.256 14a4.5 4.5 0 0 1-.229-1.004H3c.001-.246.154-.986.832-1.664C4.484 10.68 5.711 10 8 10q.39 0 .74.025c.226-.341.496-.65.804-.918Q8.844 9.002 8 9c-5 0-6 3-6 4s1 1 1 1z"/>
        </svg>
        Regisztráció
    </a>
</li>
<li class="nav-item ms-lg-2">
    <a class="nav-link nav-cart-btn" href="cart.html">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
            <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5M3.102 4l1.313 7h8.17l1.313-7zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4m7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4m-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2m7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2"/>
        </svg>
        Kosár
        <span class="cart-badge" id="cartCount">0</span>
    </a>
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
