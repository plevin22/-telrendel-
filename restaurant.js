/**
 * KLSZ Faloda - Étterem oldal JavaScript
 * Dinamikus étel betöltés a backendről
 */

// Étterem ID mapping (HTML fájlnév -> adatbázis ID)
const RESTAURANT_MAP = {
    'restaurant-reggeli.html': { id: 1, name: 'Reggeli Étterem' },
    'restaurant-sablon.html': { id: 2, name: 'Szünet Kávézó' },
    'restaurant-csulokbar.html': { id: 3, name: 'Csülök Bár' },
    'restaurant-JuiceBoo_Pécs_Smoothie_Bar.html': { id: 4, name: 'Juice&Co. Pécs Smoothie Bar' },
    'restaurant-Élemozsia Bistro.html': { id: 5, name: 'Elemózsia Bisztró' },
    'restaurant-Mátyás_Király_Vendéglő.html': { id: 6, name: 'Mátyás Király Vendéglő' },
    'restaurant-Teca_Mama_Vendéglője.html': { id: 7, name: 'Teca Mama Kisvendéglő' },
    'restaurant-Pizza_Hut.html': { id: 8, name: 'Pizza Hut Pécs' },
    'restaurant-Best_Food_Grill.html': { id: 9, name: 'Best Food Grill Pécs' }
};

// Globális változók
let currentRestaurantId = null;
let currentRestaurantName = null;
let dishes = [];

document.addEventListener('DOMContentLoaded', function() {
    // Aktuális oldal nevének meghatározása
    const currentPage = window.location.pathname.split('/').pop();
    
    // Étterem azonosítása
    const restaurantInfo = RESTAURANT_MAP[currentPage];
    
    if (restaurantInfo) {
        currentRestaurantId = restaurantInfo.id;
        currentRestaurantName = restaurantInfo.name;
        loadDishes();
    } else {
        console.error('Ismeretlen étterem oldal:', currentPage);
        // Próbáljuk meg kiolvasni az URL-ből
        tryExtractRestaurantId();
    }

    // Kosár összeg frissítése
    updateCartSidebar();
    
    // Navigáció frissítése
    updateNavigation();
});

// Próbálja kiolvasni az étterem ID-t az oldalból
function tryExtractRestaurantId() {
    // Próbáljuk kiolvasni a HTML tartalmából
    const restaurantTitle = document.querySelector('.restaurant-info h1');
    if (restaurantTitle) {
        const name = restaurantTitle.textContent.trim();
        
        // Keresés a mapping-ben név alapján
        for (const [page, info] of Object.entries(RESTAURANT_MAP)) {
            if (info.name.toLowerCase().includes(name.toLowerCase()) || 
                name.toLowerCase().includes(info.name.toLowerCase())) {
                currentRestaurantId = info.id;
                currentRestaurantName = info.name;
                loadDishes();
                return;
            }
        }
    }
    
    console.warn('Nem sikerült az étterem azonosítása');
}

// Ételek betöltése a backendről
async function loadDishes() {
    if (!currentRestaurantId) {
        console.error('Nincs étterem ID');
        return;
    }

    try {
        const result = await DishesAPI.getByRestaurant(currentRestaurantId);
        
        if (result.success && Array.isArray(result.data)) {
            dishes = result.data.filter(d => d.available);
            displayDishes(dishes);
        } else {
            console.error('Hiba az ételek betöltésekor:', result.data);
            displayError('Nem sikerült betölteni az ételeket.');
        }
    } catch (error) {
        console.error('API hiba:', error);
        displayError('Hálózati hiba történt.');
    }
}

// Ételek megjelenítése
function displayDishes(dishes) {
    // Népszerű section (első 4 étel)
    const nepszeruSection = document.querySelector('#nepszeru');
    if (nepszeruSection) {
        const popularDishes = dishes.slice(0, 4);
        updateMenuSection(nepszeruSection, popularDishes, 'Népszerű');
    }

    // Ételek section (összes étel)
    const etelekSection = document.querySelector('#etelek-section');
    if (etelekSection) {
        updateMenuSection(etelekSection, dishes, 'Ételek');
    }

    // Italok section (ha van olyan kategória)
    const italokSection = document.querySelector('#italok-section');
    if (italokSection) {
        // Itt szűrhetnénk kategória alapján, de nincs kategória mező
        // Egyelőre üresen hagyjuk vagy az utolsó néhány ételt mutatjuk
        const drinks = dishes.filter(d => 
            d.name.toLowerCase().includes('tea') || 
            d.name.toLowerCase().includes('kávé') ||
            d.name.toLowerCase().includes('latte') ||
            d.name.toLowerCase().includes('juice') ||
            d.name.toLowerCase().includes('smoothie') ||
            d.name.toLowerCase().includes('limonádé') ||
            d.name.toLowerCase().includes('cola') ||
            d.name.toLowerCase().includes('fanta') ||
            d.name.toLowerCase().includes('sprite') ||
            d.name.toLowerCase().includes('ital')
        );
        if (drinks.length > 0) {
            updateMenuSection(italokSection, drinks, 'Italok');
        }
    }

    // Desszertek section
    const desszertekSection = document.querySelector('#desszertek-section');
    if (desszertekSection) {
        const desserts = dishes.filter(d => 
            d.name.toLowerCase().includes('palacsinta') || 
            d.name.toLowerCase().includes('brownie') ||
            d.name.toLowerCase().includes('torta') ||
            d.name.toLowerCase().includes('fagyi') ||
            d.name.toLowerCase().includes('desszert') ||
            d.name.toLowerCase().includes('mousse') ||
            d.name.toLowerCase().includes('csoki') ||
            d.name.toLowerCase().includes('gesztenye')
        );
        if (desserts.length > 0) {
            updateMenuSection(desszertekSection, desserts, 'Desszertek');
        }
    }
}

// Menü szekció frissítése
function updateMenuSection(section, dishes, title) {
    let html = `<h2 class="menu-section-title">${title}</h2>`;
    
    dishes.forEach(dish => {
        html += `
            <div class="menu-item" data-dish-id="${dish.dish_id}">
                <div class="item-image"></div>
                <div class="item-details">
                    <div class="item-name">${dish.name}</div>
                    <div class="item-description">${dish.description || 'Nincs leírás'}</div>
                    <div class="item-price">${formatPrice(dish.price)}</div>
                </div>
                <button class="btn-add-to-cart" onclick="addToCart(${dish.dish_id}, '${escapeHtml(dish.name)}', ${dish.price})">Kosárba</button>
            </div>
        `;
    });
    
    section.innerHTML = html;
}

// HTML escape
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML.replace(/'/g, "\\'");
}

// Hibaüzenet megjelenítése
function displayError(message) {
    const sections = document.querySelectorAll('.menu-section');
    sections.forEach(section => {
        section.innerHTML = `
            <h2 class="menu-section-title">Hiba</h2>
            <div class="alert alert-danger">${message}</div>
        `;
    });
}

// Kosárba helyezés
function addToCart(dishId, name, price) {
    // Ellenőrizzük, hogy a kosárban van-e már másik étteremből termék
    const currentCartRestaurant = Cart.getRestaurantId();
    
    if (currentCartRestaurant && currentCartRestaurant != currentRestaurantId) {
        if (!confirm('A kosaradban már van termék egy másik étteremből. Szeretnéd üríteni a kosarat és hozzáadni ezt a terméket?')) {
            return;
        }
        Cart.clear();
    }

    // Kosárba helyezés
    Cart.addItem({
        dish_id: dishId,
        name: name,
        price: price,
        quantity: 1,
        restaurant_id: currentRestaurantId
    });

    // Étterem ID és név mentése
    Cart.setRestaurantId(currentRestaurantId);
    Cart.setRestaurantName(currentRestaurantName);

    // Sidebar frissítése
    updateCartSidebar();

    // Visszajelzés
    showAddedToCartFeedback(name);
}

// Kosár sidebar frissítése
function updateCartSidebar() {
    const cartTotal = document.querySelector('.cart-total');
    if (cartTotal) {
        cartTotal.textContent = formatPrice(Cart.getTotal());
    }
}

// "Kosárba téve" visszajelzés
function showAddedToCartFeedback(itemName) {
    // Egyszerű alert helyett szebb megoldás
    const feedback = document.createElement('div');
    feedback.className = 'cart-feedback';
    feedback.innerHTML = `✓ ${itemName} hozzáadva a kosárhoz`;
    feedback.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: #28a745;
        color: white;
        padding: 15px 25px;
        border-radius: 8px;
        z-index: 9999;
        animation: fadeInOut 2s ease-in-out;
    `;
    
    document.body.appendChild(feedback);
    
    setTimeout(() => {
        feedback.remove();
    }, 2000);
}

// CSS animáció hozzáadása
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeInOut {
        0% { opacity: 0; transform: translateY(20px); }
        20% { opacity: 1; transform: translateY(0); }
        80% { opacity: 1; transform: translateY(0); }
        100% { opacity: 0; transform: translateY(-20px); }
    }
`;
document.head.appendChild(style);

console.log('Restaurant.js betöltve');
