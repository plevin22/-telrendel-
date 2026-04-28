/**
 * KLSZ Faloda - Főoldal JavaScript
 * Népszerű éttermek dinamikus betöltése az adatbázisból
 */

// Restaurant ID → HTML aloldal mapping
const POPULAR_PAGES = {
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

// Népszerű éttermek ID-k (ezeket mutatjuk a főoldalon)
const POPULAR_IDS = [1, 2, 3];

document.addEventListener('DOMContentLoaded', function() {
    loadPopularRestaurants();

    if (typeof updateNavigation === 'function') {
        updateNavigation();
    }
});

async function loadPopularRestaurants() {
    const container = document.getElementById('popularRestaurantsContainer');
    if (!container) return;

    try {
        const result = await RestaurantsAPI.getAll();

        if (result.success && Array.isArray(result.data)) {
            // Csak a népszerű éttermeket szűrjük
            const popular = result.data.filter(r => POPULAR_IDS.includes(r.restaurant_id));
            
            if (popular.length === 0) {
                container.innerHTML = '<p class="text-center" style="color:#999;">Nincs megjeleníthető étterem.</p>';
                return;
            }

            let html = '';
            for (const restaurant of popular) {
                const id = restaurant.restaurant_id;
                const name = restaurant.name || 'Ismeretlen étterem';
                const page = POPULAR_PAGES[id] || '#';
                const imageUrl = restaurant.image_path || '';

                html += `
                    <div class="col-md-4">
                        <div class="menu-card">
                            <div class="menu-card-image">
                                <img src="${imageUrl}" alt="${name}" onerror="this.style.display='none'">
                            </div>
                            <div class="menu-card-body">
                                <h3 class="menu-card-title">${name}</h3>
                                <button class="btn btn-secondary-custom" onclick="window.location.href='${page}'">ugrás az oldalra</button>
                            </div>
                        </div>
                    </div>
                `;
            }

            container.innerHTML = html;
        }
    } catch (error) {
        console.error('Népszerű éttermek betöltési hiba:', error);
        container.innerHTML = '<p class="text-center" style="color:#ef4444;">Hiba történt a betöltéskor.</p>';
    }
}

console.log('Index.js betöltve');
