const API_BASE_URL_RATING = 'http://localhost:8080/vizsgaremek1/webresources';


 // Átlagos értékelés kiszámítása és megjelenítése

async function loadAverageRating() {
    try {
        // Összes értékelés lekérése
        const response = await fetch(`${API_BASE_URL_RATING}/reviews/GetRecentReviews/1000`);
        
        if (response.ok) {
            const reviews = await response.json();
            
            if (reviews && reviews.length > 0) {
                // Átlag kiszámítása
                const totalRating = reviews.reduce((sum, review) => sum + (review.rating || 0), 0);
                const averageRating = (totalRating / reviews.length).toFixed(1);
                
                // Megjelenítés az összes helyen ahol az id="averageRating" van
                const ratingElements = document.querySelectorAll('#averageRating, .average-rating-value');
                ratingElements.forEach(el => {
                    el.textContent = `Átlagosan ${averageRating}/5 értékelés a felhasználóinktól`;
                });
                
                // Ha csak a szám kell
                const ratingNumberElements = document.querySelectorAll('.average-rating-number');
                ratingNumberElements.forEach(el => {
                    el.textContent = averageRating;
                });
            }
        }
    } catch (error) {
        console.error('Hiba az átlagos értékelés betöltésekor:', error);
    }
}

// Oldal betöltésekor automatikusan lefut
document.addEventListener('DOMContentLoaded', loadAverageRating);
