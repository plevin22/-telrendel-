// Sidebar toggle
document.getElementById('sidebarToggle').addEventListener('click', () => document.getElementById('sidebar').classList.toggle('show'));

// API URL
const API_BASE = 'http://localhost:8080/vizsgaremek1/webresources';

// Globális változók
let allRestaurants = [];
let allDishes = [];
let myRestaurants = []; // A bejelentkezett tulajdonos éttermei

// Oldal betöltésekor
document.addEventListener('DOMContentLoaded', function() {
    loadStatistics();
    initializeOwnerFeatures();
});

/**
 * Tulajdonosi funkciók inicializálása
 * Csak restaurant_owner szerepkörű felhasználóknak jelennek meg
 */
function initializeOwnerFeatures() {
    const userRole = Session.getUserRole();
    const ownerElements = document.querySelectorAll('.owner-only');
    
    if (userRole === 'restaurant_owner') {
        // Megjelenítjük a tulajdonosi elemeket
        ownerElements.forEach(el => {
            el.style.display = '';
        });
        
        // Betöltjük az adatokat
        loadRestaurants();
        loadDishes();
    } else {
        // Elrejtjük a tulajdonosi elemeket (alapértelmezett)
        ownerElements.forEach(el => {
            el.style.display = 'none';
        });
    }
}

/**
 * Statisztikák betöltése
 */
async function loadStatistics() {
    try {
        // Rendelések lekérése
        const ordersRes = await fetch(`${API_BASE}/orders/GetAllOrders`);
        if (ordersRes.ok) {
            const orders = await ordersRes.json();
            const today = new Date().toISOString().split('T')[0];
            let todayOrders = 0, dailyRevenue = 0, totalRevenue = 0;
            
            // Ha tulajdonos, csak a saját éttermei rendeléseit számoljuk
            const userRole = Session.getUserRole();
            const userId = Session.getUserId();
            
            orders.forEach(o => {
                // Ha tulajdonos és van myRestaurants, szűrjük
                if (userRole === 'restaurant_owner' && myRestaurants.length > 0) {
                    const myRestaurantIds = myRestaurants.map(r => r.restaurant_id);
                    if (!myRestaurantIds.includes(o.restaurant_id)) {
                        return; // Nem a mi éttermünk rendelése
                    }
                }
                
                totalRevenue += parseFloat(o.total_price) || 0;
                if ((o.created_at || '').split('T')[0] === today) {
                    todayOrders++;
                    dailyRevenue += parseFloat(o.total_price) || 0;
                }
            });
            document.getElementById('todayOrders').textContent = todayOrders;
            document.getElementById('dailyRevenue').textContent = formatPrice(dailyRevenue);
            document.getElementById('totalRevenue').textContent = formatPrice(totalRevenue);
        }

        // Felhasználók lekérése (csak admin/owner látja az összeset)
        const usersRes = await fetch(`${API_BASE}/users/GetAllUsers`);
        if (usersRes.ok) {
            document.getElementById('totalUsers').textContent = (await usersRes.json()).length;
        }
    } catch (e) {
        console.error('Hiba az adatok betöltésekor:', e);
    }
}

/**
 * Ár formázása
 */
function formatPrice(p) {
    return new Intl.NumberFormat('hu-HU').format(Math.round(p)) + ' Ft';
}

// =====================================================
// SZEKCIÓ VÁLTÁS
// =====================================================

function showDashboard() {
    document.getElementById('dashboardSection').style.display = 'block';
    document.getElementById('restaurantsSection').style.display = 'none';
    document.getElementById('dishesSection').style.display = 'none';
    updateSidebarActive('Dashboard');
}

function showRestaurantsSection() {
    if (!checkOwnerPermission()) return;
    
    document.getElementById('dashboardSection').style.display = 'none';
    document.getElementById('restaurantsSection').style.display = 'block';
    document.getElementById('dishesSection').style.display = 'none';
    updateSidebarActive('Éttermek kezelése');
    loadRestaurants();
}

function showDishesSection() {
    if (!checkOwnerPermission()) return;
    
    document.getElementById('dashboardSection').style.display = 'none';
    document.getElementById('restaurantsSection').style.display = 'none';
    document.getElementById('dishesSection').style.display = 'block';
    updateSidebarActive('Ételek kezelése');
    loadDishes();
    populateRestaurantFilter();
}

function updateSidebarActive(menuName) {
    document.querySelectorAll('.sidebar-link').forEach(link => {
        link.classList.remove('active');
        if (link.textContent.trim().includes(menuName)) {
            link.classList.add('active');
        }
    });
}

/**
 * Tulajdonosi jogosultság ellenőrzése
 */
function checkOwnerPermission() {
    const userRole = Session.getUserRole();
    if (userRole !== 'restaurant_owner') {
        alert('⛔ Nincs jogosultságod ehhez a funkcióhoz!\nCsak étterem tulajdonosok használhatják.');
        return false;
    }
    return true;
}

/**
 * Ellenőrzi, hogy a bejelentkezett tulajdonos kezelheti-e az adott éttermet
 */
function canManageRestaurant(restaurantId) {
    const userId = Session.getUserId();
    const restaurant = allRestaurants.find(r => r.restaurant_id === restaurantId);
    
    if (!restaurant) return false;
    
    // Ellenőrizzük, hogy a bejelentkezett user a tulajdonos-e
    return restaurant.owner_id === userId;
}

/**
 * Ellenőrzi, hogy a bejelentkezett tulajdonos kezelheti-e az adott ételt
 */
function canManageDish(dishId) {
    const dish = allDishes.find(d => d.dish_id === dishId);
    if (!dish) return false;
    
    return canManageRestaurant(dish.restaurant_id);
}

// =====================================================
// ÉTTERMEK KEZELÉSE - CSAK SAJÁT ÉTTERMEK
// =====================================================

/**
 * Éttermek betöltése
 */
async function loadRestaurants() {
    try {
        const response = await RestaurantsAPI.getAll();
        if (response.success) {
            allRestaurants = response.data;
            
            // Szűrjük a saját éttermekre
            const userId = Session.getUserId();
            myRestaurants = allRestaurants.filter(r => r.owner_id === userId);
            
            // Tulajdonos csak a saját éttermeit látja
            renderRestaurantsTable(myRestaurants);
            
            // Frissítjük a statisztikákat is
            loadStatistics();
        } else {
            console.error('Hiba az éttermek betöltésekor:', response.data);
        }
    } catch (e) {
        console.error('Hiba:', e);
    }
}

/**
 * Éttermek táblázat renderelése
 */
function renderRestaurantsTable(restaurants) {
    const tbody = document.getElementById('restaurantsTableBody');
    
    if (!restaurants || restaurants.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center">Nincs saját éttermed a rendszerben.</td></tr>';
        return;
    }
    
    tbody.innerHTML = restaurants.map(r => `
        <tr>
            <td>${r.restaurant_id}</td>
            <td>${escapeHtml(r.name || '')}</td>
            <td>${escapeHtml(r.address || '')}</td>
            <td>${escapeHtml(r.phone || '-')}</td>
            <td>${escapeHtml(r.open_hours || '-')}</td>
            <td>
                <button class="btn-edit" onclick="editRestaurant(${r.restaurant_id})">
                    ✏️ Szerkesztés
                </button>
                <button class="btn-delete" onclick="deleteRestaurant(${r.restaurant_id}, '${escapeHtml(r.name)}')">
                    🗑️ Törlés
                </button>
            </td>
        </tr>
    `).join('');
}

/**
 * Étterem szerkesztése
 */
async function editRestaurant(id) {
    if (!checkOwnerPermission()) return;
    
    // Ellenőrizzük, hogy a sajátja-e
    if (!canManageRestaurant(id)) {
        alert('⛔ Csak a saját éttermedet szerkesztheted!');
        return;
    }
    
    try {
        const response = await RestaurantsAPI.getById(id);
        if (response.success) {
            const r = response.data;
            document.getElementById('editRestaurantId').value = r.restaurant_id;
            document.getElementById('editRestaurantName').value = r.name || '';
            document.getElementById('editRestaurantDescription').value = r.description || '';
            document.getElementById('editRestaurantAddress').value = r.address || '';
            document.getElementById('editRestaurantPhone').value = r.phone || '';
            document.getElementById('editRestaurantHours').value = r.open_hours || '';
            document.getElementById('editRestaurantImage').value = r.image_path || '';
            
            new bootstrap.Modal(document.getElementById('editRestaurantModal')).show();
        }
    } catch (e) {
        console.error('Hiba:', e);
        alert('Hiba történt az étterem adatainak betöltésekor.');
    }
}

/**
 * Étterem mentése
 */
async function saveRestaurant() {
    if (!checkOwnerPermission()) return;
    
    const id = document.getElementById('editRestaurantId').value;
    
    // Ellenőrizzük, hogy a sajátja-e
    if (!canManageRestaurant(parseInt(id))) {
        alert('⛔ Csak a saját éttermedet módosíthatod!');
        return;
    }
    
    const data = {
        name: document.getElementById('editRestaurantName').value,
        description: document.getElementById('editRestaurantDescription').value,
        address: document.getElementById('editRestaurantAddress').value,
        phone: document.getElementById('editRestaurantPhone').value,
        open_hours: document.getElementById('editRestaurantHours').value,
        image_path: document.getElementById('editRestaurantImage').value
    };
    
    try {
        const response = await RestaurantsAPI.update(id, data);
        if (response.success) {
            alert('✅ Étterem sikeresen módosítva!');
            bootstrap.Modal.getInstance(document.getElementById('editRestaurantModal')).hide();
            loadRestaurants();
        } else {
            alert('❌ Hiba történt: ' + (response.data.message || 'Ismeretlen hiba'));
        }
    } catch (e) {
        console.error('Hiba:', e);
        alert('Hiba történt a mentés során.');
    }
}

/**
 * Étterem törlése
 */
async function deleteRestaurant(id, name) {
    if (!checkOwnerPermission()) return;
    
    // Ellenőrizzük, hogy a sajátja-e
    if (!canManageRestaurant(id)) {
        alert('⛔ Csak a saját éttermedet törölheted!');
        return;
    }
    
    if (!confirm(`⚠️ Biztosan törölni szeretnéd a(z) "${name}" éttermet?\n\nEz a művelet nem vonható vissza és az összes hozzá tartozó étel is törlődik!`)) {
        return;
    }
    
    try {
        const response = await RestaurantsAPI.delete(id);
        if (response.success) {
            alert('✅ Étterem sikeresen törölve!');
            loadRestaurants();
        } else {
            alert('❌ Hiba történt: ' + (response.data.message || 'Ismeretlen hiba'));
        }
    } catch (e) {
        console.error('Hiba:', e);
        alert('Hiba történt a törlés során.');
    }
}

// =====================================================
// ÉTELEK KEZELÉSE - CSAK SAJÁT ÉTTERMEK ÉTELEI
// =====================================================

/**
 * Ételek betöltése
 */
async function loadDishes() {
    try {
        const response = await DishesAPI.getAll();
        if (response.success) {
            allDishes = response.data;
            
            // Szűrjük a saját éttermek ételeire
            const myRestaurantIds = myRestaurants.map(r => r.restaurant_id);
            const myDishes = allDishes.filter(d => myRestaurantIds.includes(d.restaurant_id));
            
            renderDishesTable(myDishes);
        } else {
            console.error('Hiba az ételek betöltésekor:', response.data);
        }
    } catch (e) {
        console.error('Hiba:', e);
    }
}

/**
 * Ételek táblázat renderelése
 */
function renderDishesTable(dishes) {
    const tbody = document.getElementById('dishesTableBody');
    
    if (!dishes || dishes.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center">Nincs megjeleníthető étel a saját éttermeidben.</td></tr>';
        return;
    }
    
    tbody.innerHTML = dishes.map(d => {
        const restaurant = allRestaurants.find(r => r.restaurant_id === d.restaurant_id);
        const restaurantName = restaurant ? restaurant.name : `#${d.restaurant_id}`;
        
        return `
            <tr>
                <td>${d.dish_id}</td>
                <td>
                    ${d.image_url ? `<img src="${d.image_url}" alt="${escapeHtml(d.name)}" onerror="this.style.display='none'">` : '-'}
                </td>
                <td>${escapeHtml(d.name || '')}</td>
                <td>${escapeHtml((d.description || '').substring(0, 50))}${(d.description || '').length > 50 ? '...' : ''}</td>
                <td>${formatPrice(d.price || 0)}</td>
                <td>${escapeHtml(restaurantName)}</td>
                <td>
                    <button class="btn-edit" onclick="editDish(${d.dish_id})">
                        ✏️ Szerkesztés
                    </button>
                    <button class="btn-delete" onclick="deleteDish(${d.dish_id}, '${escapeHtml(d.name)}')">
                        🗑️ Törlés
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

/**
 * Étterem szűrő feltöltése - csak saját éttermek
 */
function populateRestaurantFilter() {
    const select = document.getElementById('restaurantFilter');
    const editSelect = document.getElementById('editDishRestaurant');
    
    // Szűrő - csak saját éttermek
    select.innerHTML = '<option value="">Összes saját étterem</option>';
    myRestaurants.forEach(r => {
        select.innerHTML += `<option value="${r.restaurant_id}">${escapeHtml(r.name)}</option>`;
    });
    
    // Szerkesztő modal - csak saját éttermek
    editSelect.innerHTML = '';
    myRestaurants.forEach(r => {
        editSelect.innerHTML += `<option value="${r.restaurant_id}">${escapeHtml(r.name)}</option>`;
    });
}

/**
 * Ételek szűrése étterem szerint
 */
function filterDishesByRestaurant() {
    const selectedId = document.getElementById('restaurantFilter').value;
    const myRestaurantIds = myRestaurants.map(r => r.restaurant_id);
    
    // Csak a saját éttermek ételeit szűrjük
    let filteredDishes = allDishes.filter(d => myRestaurantIds.includes(d.restaurant_id));
    
    if (selectedId !== '') {
        filteredDishes = filteredDishes.filter(d => d.restaurant_id == selectedId);
    }
    
    renderDishesTable(filteredDishes);
}

/**
 * Étel szerkesztése
 */
async function editDish(id) {
    if (!checkOwnerPermission()) return;
    
    // Ellenőrizzük, hogy a saját éttermének étele-e
    if (!canManageDish(id)) {
        alert('⛔ Csak a saját éttermeid ételeit szerkesztheted!');
        return;
    }
    
    try {
        const response = await DishesAPI.getById(id);
        if (response.success) {
            const d = response.data;
            document.getElementById('editDishId').value = d.dish_id;
            document.getElementById('editDishName').value = d.name || '';
            document.getElementById('editDishDescription').value = d.description || '';
            document.getElementById('editDishPrice').value = d.price || 0;
            document.getElementById('editDishRestaurant').value = d.restaurant_id || '';
            // image_url az adatbázisban
            document.getElementById('editDishImage').value = d.image_url || '';
            // available: 1 = Igen, 0 = Nem
            document.getElementById('editDishAvailable').value = (d.available === 1 || d.available === true) ? '1' : '0';
            
            new bootstrap.Modal(document.getElementById('editDishModal')).show();
        }
    } catch (e) {
        console.error('Hiba:', e);
        alert('Hiba történt az étel adatainak betöltésekor.');
    }
}

/**
 * Étel mentése
 */
async function saveDish() {
    if (!checkOwnerPermission()) return;
    
    const id = document.getElementById('editDishId').value;
    
    // Ellenőrizzük, hogy a saját éttermének étele-e
    if (!canManageDish(parseInt(id))) {
        alert('⛔ Csak a saját éttermeid ételeit módosíthatod!');
        return;
    }
    
    const data = {
        name: document.getElementById('editDishName').value,
        description: document.getElementById('editDishDescription').value,
        price: parseFloat(document.getElementById('editDishPrice').value) || 0,
        image_url: document.getElementById('editDishImage').value,
        available: document.getElementById('editDishAvailable').value === '1'
    };
    
    try {
        const response = await DishesAPI.update(id, data);
        if (response.success) {
            alert('✅ Étel sikeresen módosítva!');
            bootstrap.Modal.getInstance(document.getElementById('editDishModal')).hide();
            loadDishes();
        } else {
            alert('❌ Hiba történt: ' + (response.data.message || 'Ismeretlen hiba'));
        }
    } catch (e) {
        console.error('Hiba:', e);
        alert('Hiba történt a mentés során.');
    }
}

/**
 * Étel törlése
 */
async function deleteDish(id, name) {
    if (!checkOwnerPermission()) return;
    
    // Ellenőrizzük, hogy a saját éttermének étele-e
    if (!canManageDish(id)) {
        alert('⛔ Csak a saját éttermeid ételeit törölheted!');
        return;
    }
    
    if (!confirm(`⚠️ Biztosan törölni szeretnéd a(z) "${name}" ételt?\n\nEz a művelet nem vonható vissza!`)) {
        return;
    }
    
    try {
        const response = await DishesAPI.delete(id);
        if (response.success) {
            alert('✅ Étel sikeresen törölve!');
            loadDishes();
        } else {
            alert('❌ Hiba történt: ' + (response.data.message || 'Ismeretlen hiba'));
        }
    } catch (e) {
        console.error('Hiba:', e);
        alert('Hiba történt a törlés során.');
    }
}

// =====================================================
// SEGÉDFÜGGVÉNYEK
// =====================================================

/**
 * HTML escape a XSS támadások ellen
 */
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
