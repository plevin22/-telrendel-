

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
                const openHours = restaurant.open_hours || '';
                
                const isOpen = checkIfOpen(openHours);
                const statusClass = isOpen ? 'open' : 'closed';
                const statusText = isOpen ? 'Nyitva' : 'Zárva';

                html += `
                    <div class="col-md-4">
                        <div class="menu-card">
                            <div class="menu-card-image">
                                <img src="${imageUrl}" alt="${name}" onerror="this.style.display='none'">
                            </div>
                            <div class="menu-card-body">
                                <h3 class="menu-card-title">${name}</h3>
                                <div class="menu-card-info">
                                    <span class="status-badge ${statusClass}">${statusText}</span>
                                    ${openHours ? `<span>${openHours}</span>` : ''}
                                </div>
                                <button class="btn btn-secondary-custom" onclick="window.location.href='${page}'">Megnézem</button>
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

function checkIfOpen(openHours) {
    if (!openHours) return false;
    try {
        const now = new Date();
        const currentMinutes = now.getHours() * 60 + now.getMinutes();
        const parts = openHours.split('-').map(s => s.trim());
        if (parts.length !== 2) return false;
        const openTime = parseTime(parts[0]);
        const closeTime = parseTime(parts[1]);
        if (openTime === null || closeTime === null) return false;
        if (closeTime < openTime) {
            return currentMinutes >= openTime || currentMinutes < closeTime;
        }
        return currentMinutes >= openTime && currentMinutes < closeTime;
    } catch (e) {
        return false;
    }
}

function parseTime(timeStr) {
    const match = timeStr.match(/(\d{1,2}):(\d{2})/);
    if (!match) return null;
    return parseInt(match[1]) * 60 + parseInt(match[2]);
}

console.log('Index.js betöltve');