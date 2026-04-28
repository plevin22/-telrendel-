/**
 * KLSZ Faloda - Éttermek dinamikus betöltése az adatbázisból
 * A képeket az image_path mezőből tölti be
 */

// Restaurant ID → HTML aloldal mapping
const RESTAURANT_PAGES = {
    1: 'restaurant-reggeli.html',
    2: 'restaurant-szunetkave.html',
    3: 'restaurant-csulokbar.html',
    4: 'restaurant-JuiceBoo_Pecs_Smoothie_Bar.html',
    5: 'restaurant-elemozsia-Bistro.html',
    6: 'restaurant-Matyas-kiraly-vendeglo.html',
    7: 'restaurant-Teca_Mama_Vendeglo.html',
    8: 'restaurant-Pizza_Hut.html',
    9: 'restaurant-Best_Food_Grill.html'
};

// Fallback képek ha nincs image_path az adatbázisban
const FALLBACK_IMAGES = {
    1: 'reggeli.jpg',
    2: 'szunetkavezo.webp',
    3: 'csulokbar másolata (2).webp',
    4: 'Juice&Co..jpg',
    5: 'elemozsiabisztro.png',
    6: 'matyaskiralyvendeglo.png',
    7: 'tecamama.avif',
    8: 'pizzahut.png',
    9: 'BestFoodGrill.png'
};

document.addEventListener('DOMContentLoaded', function() {
    loadRestaurants();

    // Navigáció frissítése
    if (typeof updateNavigation === 'function') {
        updateNavigation();
    }
});

async function loadRestaurants() {
    const container = document.getElementById('restaurantsContainer');

    try {
        const result = await RestaurantsAPI.getAll();

        if (result.success && Array.isArray(result.data) && result.data.length > 0) {
            let html = '';

            for (const restaurant of result.data) {
                const id = restaurant.restaurant_id;
                const name = restaurant.name || 'Ismeretlen étterem';
                const page = RESTAURANT_PAGES[id] || '#';
                
                // Kép: adatbázisból (image_path), ha nincs akkor fallback
                const imageUrl = restaurant.image_path || FALLBACK_IMAGES[id] || '';
                
                html += `
                    <div class="col-lg-4 col-md-6">
                        <div class="restaurant-card">
                            <div class="restaurant-image">
                                <img src="${imageUrl}" alt="${name}" onerror="this.src='${FALLBACK_IMAGES[id] || ''}'">
                            </div>
                            <div class="restaurant-body">
                                <h3 class="restaurant-name">${name}</h3>
                                <a href="${page}" class="btn-view-restaurant">ugrás az oldalra</a>
                            </div>
                        </div>
                    </div>
                `;
            }

            container.innerHTML = html;
        } else {
            container.innerHTML = '<div class="text-center py-5"><p style="color: #999;">Nem találhatóak éttermek.</p></div>';
        }
    } catch (error) {
        console.error('Éttermek betöltési hiba:', error);
        container.innerHTML = '<div class="text-center py-5"><p style="color: #ef4444;">Hiba történt az éttermek betöltésekor.</p></div>';
    }
}

console.log('Restaurants-loader.js betöltve');
