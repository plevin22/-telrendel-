/**
 * KLSZ Faloda - Értékelések oldal JavaScript
 * Backend API-hoz csatlakozik a reviews végpontokon keresztül
 */

const RATING_LABELS = {
    1: 'Borzalmas',
    2: 'Rossz',
    3: 'Elmegy',
    4: 'Jó',
    5: 'Tökéletes'
};

let selectedRating = 0;
let selectedOrderId = null;
let completedOrders = [];
let myReviews = [];

document.addEventListener('DOMContentLoaded', function() {
    initPage();
    loadRecentReviews();
    updateNavigation();
});

// ===== INIT =====
async function initPage() {
    if (Session.isLoggedIn()) {
        document.getElementById('reviewFormSection').style.display = 'block';
        document.getElementById('loginPrompt').style.display = 'none';
        document.getElementById('myReviewsSection').style.display = 'block';

        await loadCompletedOrders();
        await loadMyReviews();
        initStarRating();
        initCommentCounter();
        initSubmitButton();

        // Ha URL-ben van order_id, automatikusan kiválasztjuk és elrejtjük a dropdown-t
        const urlParams = new URLSearchParams(window.location.search);
        const preselectedOrderId = urlParams.get('order_id');
        if (preselectedOrderId) {
            const select = document.getElementById('orderSelect');
            select.value = preselectedOrderId;
            
            // Ha sikerült kiválasztani
            if (select.value === preselectedOrderId) {
                select.dispatchEvent(new Event('change'));
                
                // Dropdown elrejtése, helyette info szöveg
                const order = completedOrders.find(o => o.order_id === parseInt(preselectedOrderId));
                if (order) {
                    const orderInfo = document.createElement('div');
                    orderInfo.style.cssText = 'background: #2c2c2c; border: 1px solid #d4a528; border-radius: 8px; padding: 0.75rem 1rem; color: #fff; margin-bottom: 1rem;';
                    orderInfo.innerHTML = `<strong style="color: #d4a528;">Rendelés #${order.order_id}</strong> — ${order.restaurant_name || 'Étterem'} — ${formatPrice(order.total_price)}`;
                    select.parentElement.replaceChild(orderInfo, select.parentElement.querySelector('.form-select'));
                    // Label frissítése
                    const label = select.parentElement.querySelector('label');
                    if (label) label.textContent = 'Kiválasztott rendelés:';
                }
            }
        }
    } else {
        document.getElementById('reviewFormSection').style.display = 'none';
        document.getElementById('loginPrompt').style.display = 'block';
        document.getElementById('myReviewsSection').style.display = 'none';
    }
}

// ===== LOAD COMPLETED ORDERS =====
async function loadCompletedOrders() {
    const userId = Session.getUserId();
    if (!userId) return;

    try {
        const result = await OrdersAPI.getByUser(userId);
        if (result.success && Array.isArray(result.data)) {
            completedOrders = result.data.filter(o => o.status === 'completed');
            await populateOrderSelect();
        }
    } catch (error) {
        console.error('Hiba a rendelések betöltésekor:', error);
    }
}

// ===== POPULATE ORDER DROPDOWN =====
async function populateOrderSelect() {
    const select = document.getElementById('orderSelect');
    select.innerHTML = '<option value="">-- Válassz egy teljesített rendelést --</option>';

    if (completedOrders.length === 0) {
        select.innerHTML = '<option value="">Nincs teljesített rendelésed</option>';
        return;
    }

    // Fetch restaurant names for each order
    for (const order of completedOrders) {
        try {
            const restRes = await fetch(`${API_BASE_URL}/restaurants/GetRestaurantById/${order.restaurant_id}`);
            if (restRes.ok) {
                const restaurant = await restRes.json();
                order.restaurant_name = restaurant.name || `Étterem #${order.restaurant_id}`;
            } else {
                order.restaurant_name = `Étterem #${order.restaurant_id}`;
            }
        } catch {
            order.restaurant_name = `Étterem #${order.restaurant_id}`;
        }

        const date = order.created_at ? new Date(order.created_at).toLocaleDateString('hu-HU') : '';
        const price = formatPrice(order.total_price);
        const option = document.createElement('option');
        option.value = order.order_id;
        option.textContent = `#${order.order_id} — ${order.restaurant_name} — ${price} (${date})`;
        select.appendChild(option);
    }

    // Order select change handler
    select.addEventListener('change', function() {
        const orderId = parseInt(this.value);
        if (orderId) {
            selectedOrderId = orderId;
            document.getElementById('starRatingInput').style.display = 'block';
            document.getElementById('commentInput').style.display = 'block';
            document.getElementById('submitReviewBtn').style.display = 'block';
            // Csak a csillagokat és kommentet reseteljük, az orderId-t NEM
            selectedRating = 0;
            highlightStars(0);
            document.getElementById('ratingLabel').textContent = '';
            document.getElementById('reviewComment').value = '';
            document.getElementById('charCount').textContent = '0';
            updateSubmitButton();
        } else {
            selectedOrderId = null;
            document.getElementById('starRatingInput').style.display = 'none';
            document.getElementById('commentInput').style.display = 'none';
            document.getElementById('submitReviewBtn').style.display = 'none';
        }
    });
}

// ===== STAR RATING =====
function initStarRating() {
    const stars = document.querySelectorAll('.star-btn');
    const label = document.getElementById('ratingLabel');

    stars.forEach(star => {
        // Hover effect
        star.addEventListener('mouseenter', function() {
            const rating = parseInt(this.dataset.rating);
            highlightStars(rating);
            label.textContent = RATING_LABELS[rating];
        });

        star.addEventListener('mouseleave', function() {
            highlightStars(selectedRating);
            label.textContent = selectedRating ? RATING_LABELS[selectedRating] : '';
        });

        // Click to select
        star.addEventListener('click', function() {
            selectedRating = parseInt(this.dataset.rating);
            highlightStars(selectedRating);
            label.textContent = RATING_LABELS[selectedRating];
            updateSubmitButton();
        });
    });
}

function highlightStars(rating) {
    const stars = document.querySelectorAll('.star-btn');
    stars.forEach(star => {
        const starRating = parseInt(star.dataset.rating);
        if (starRating <= rating) {
            star.classList.add('selected');
        } else {
            star.classList.remove('selected');
        }
    });
}

// ===== COMMENT COUNTER =====
function initCommentCounter() {
    const textarea = document.getElementById('reviewComment');
    const counter = document.getElementById('charCount');
    const counterWrapper = textarea.closest('.comment-input').querySelector('.char-counter');

    textarea.addEventListener('input', function() {
        const len = this.value.length;
        counter.textContent = len;

        counterWrapper.classList.remove('warning', 'limit');
        if (len >= 150) {
            counterWrapper.classList.add('limit');
        } else if (len >= 120) {
            counterWrapper.classList.add('warning');
        }
    });
}

// ===== SUBMIT =====
function initSubmitButton() {
    document.getElementById('submitReviewBtn').addEventListener('click', submitReview);
}

function updateSubmitButton() {
    const btn = document.getElementById('submitReviewBtn');
    btn.disabled = !(selectedOrderId && selectedRating > 0);
}

async function submitReview() {
    const btn = document.getElementById('submitReviewBtn');
    const successMsg = document.getElementById('successMsg');
    const errorMsg = document.getElementById('errorMsg');

    successMsg.style.display = 'none';
    errorMsg.style.display = 'none';

    if (!selectedOrderId || !selectedRating) {
        showError('Válassz rendelést és adj értékelést!');
        return;
    }

    const comment = document.getElementById('reviewComment').value.trim();
    if (comment.length > 150) {
        showError('Az üzenet maximum 150 karakter lehet!');
        return;
    }

    btn.disabled = true;
    btn.textContent = 'Küldés...';

    try {
        // A kiválasztott rendelésből kiolvassuk a restaurant_id-t
        const selectedOrder = completedOrders.find(o => o.order_id === selectedOrderId);
        const restaurantId = selectedOrder ? selectedOrder.restaurant_id : null;

        const reviewData = {
            user_id: Session.getUserId(),
            order_id: selectedOrderId,
            restaurant_id: restaurantId,
            dish_id: null,
            rating: selectedRating,
            comment: comment || null
        };

        const result = await ReviewsAPI.add(reviewData);

        if (result.success) {
            showSuccess('Értékelés sikeresen elküldve!');
            selectedOrderId = null;
            resetForm();
            const orderSelect = document.getElementById('orderSelect');
            if (orderSelect) orderSelect.value = '';
            document.getElementById('starRatingInput').style.display = 'none';
            document.getElementById('commentInput').style.display = 'none';
            document.getElementById('submitReviewBtn').style.display = 'none';

            // Reload reviews
            await loadMyReviews();
            await loadRecentReviews();
        } else {
            const msg = result.data?.message || result.data?.error || 'Hiba történt az értékelés küldésekor.';
            showError(msg);
        }
    } catch (error) {
        console.error('Értékelés küldési hiba:', error);
        showError('Hálózati hiba történt.');
    }

    btn.disabled = false;
    btn.textContent = 'Értékelés küldése';
    updateSubmitButton();
}

// ===== LOAD MY REVIEWS =====
async function loadMyReviews() {
    const userId = Session.getUserId();
    if (!userId) return;

    const container = document.getElementById('myReviewsList');

    try {
        const result = await ReviewsAPI.getByUser(userId);

        if (result.success && Array.isArray(result.data) && result.data.length > 0) {
            myReviews = result.data;
            container.innerHTML = myReviews.map(r => renderReviewCard(r, true)).join('');
        } else {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">📝</div>
                    <p>Még nincs értékelésed. Rendelj és oszd meg véleményed!</p>
                </div>`;
        }
    } catch (error) {
        console.error('Saját értékelések betöltési hiba:', error);
        container.innerHTML = '<div class="empty-state"><p>Hiba történt a betöltés során.</p></div>';
    }
}

// ===== LOAD RECENT REVIEWS =====
async function loadRecentReviews() {
    const container = document.getElementById('recentReviewsList');

    try {
        const result = await ReviewsAPI.getRecent(20);

        if (result.success && Array.isArray(result.data) && result.data.length > 0) {
            container.innerHTML = result.data.map(r => renderReviewCard(r, false)).join('');
        } else {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">⭐</div>
                    <p>Még nincsenek értékelések. Legyél az első!</p>
                </div>`;
        }
    } catch (error) {
        console.error('Értékelések betöltési hiba:', error);
        container.innerHTML = '<div class="empty-state"><p>Hiba történt a betöltés során.</p></div>';
    }
}

// ===== RENDER REVIEW CARD =====
function renderReviewCard(review, showActions) {
    const userName = review.user_name || review.name || 'Ismeretlen';
    const restaurantName = review.restaurant_name || `Étterem #${review.restaurant_id || '?'}`;
    const initials = getInitials(userName);
    const stars = renderStars(review.rating);
    const ratingLabel = RATING_LABELS[review.rating] || '';
    const date = review.created_at ? new Date(review.created_at).toLocaleDateString('hu-HU', {
        year: 'numeric', month: 'long', day: 'numeric'
    }) : '';

    const commentHtml = review.comment
        ? `<div class="review-comment">${escapeHtml(review.comment)}</div>`
        : `<div class="review-no-comment">Nincs szöveges értékelés</div>`;

    // Rendelt ételek megjelenítése
    let dishesHtml = '';
    if (review.dishes && review.dishes.length > 0) {
        const dishNames = review.dishes.map(d => escapeHtml(d.name)).join(', ');
        dishesHtml = `<div class="review-dishes">🍽️ ${dishNames}</div>`;
    }

    const actionsHtml = showActions ? `
        <div class="review-actions">
            <button class="btn-review-action btn-review-delete" onclick="deleteReview(${review.review_id})">Törlés</button>
        </div>` : '';

    return `
        <div class="review-card">
            <div class="review-header">
                <div class="review-user-info">
                    <div class="review-avatar">${initials}</div>
                    <div>
                        <div class="review-name">${escapeHtml(userName)}</div>
                        <div class="review-restaurant">🍽️ ${escapeHtml(restaurantName)}</div>
                    </div>
                </div>
                <div class="review-meta">
                    <div class="review-stars">${stars}</div>
                    <div class="review-rating-label">${ratingLabel} (${review.rating}/5)</div>
                    <div class="review-date">${date}</div>
                </div>
            </div>
            ${dishesHtml}
            ${commentHtml}
            ${actionsHtml}
        </div>`;
}

// ===== RENDER STARS =====
function renderStars(rating) {
    let html = '';
    for (let i = 1; i <= 5; i++) {
        html += i <= rating
            ? '<span class="star-filled">★</span>'
            : '<span class="star-empty">★</span>';
    }
    return html;
}

// ===== DELETE REVIEW =====
async function deleteReview(reviewId) {
    if (!confirm('Biztosan törölni szeretnéd ezt az értékelést?')) return;

    try {
        const result = await ReviewsAPI.delete(reviewId);
        if (result.success) {
            await loadMyReviews();
            await loadRecentReviews();
        } else {
            alert('Hiba történt a törlés során: ' + (result.data?.message || 'Ismeretlen hiba'));
        }
    } catch (error) {
        alert('Hálózati hiba történt.');
    }
}

// ===== HELPERS =====
function resetForm() {
    selectedRating = 0;
    highlightStars(0);
    document.getElementById('ratingLabel').textContent = '';
    document.getElementById('reviewComment').value = '';
    document.getElementById('charCount').textContent = '0';
    document.getElementById('successMsg').style.display = 'none';
    document.getElementById('errorMsg').style.display = 'none';
    updateSubmitButton();
}

function showSuccess(msg) {
    const el = document.getElementById('successMsg');
    el.textContent = msg;
    el.style.display = 'block';
    setTimeout(() => { el.style.display = 'none'; }, 5000);
}

function showError(msg) {
    const el = document.getElementById('errorMsg');
    el.textContent = msg;
    el.style.display = 'block';
    setTimeout(() => { el.style.display = 'none'; }, 5000);
}

function getInitials(name) {
    if (!name) return '?';
    return name.split(' ').map(n => n[0]).join('').toUpperCase().substring(0, 2);
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function formatPrice(price) {
    return new Intl.NumberFormat('hu-HU').format(Math.round(parseFloat(price) || 0)) + ' Ft';
}

// ===== NAVIGATION (from api.js pattern) =====
function updateNavigation() {
    if (typeof Session !== 'undefined' && Session.isLoggedIn && Session.isLoggedIn()) {
        // Navigation is handled by api.js updateNavigation if loaded
    }
}

console.log('Reviews.js betöltve');
