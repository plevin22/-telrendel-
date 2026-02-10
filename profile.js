/**
 * KLSZ Faloda - Profil oldal JavaScript
 * Felhasználói adatok és rendelések megjelenítése
 */

document.addEventListener('DOMContentLoaded', function() {
    // Bejelentkezés ellenőrzése
    if (!Session.isLoggedIn()) {
        window.location.href = 'login.html';
        return;
    }

    // Navigáció frissítése
    updateNavigation();

    // Felhasználói adatok betöltése
    loadUserProfile();

    // Rendelések betöltése
    loadUserOrders();
});

// Felhasználói profil betöltése
async function loadUserProfile() {
    const user = Session.getUser();
    
    // Alapadatok megjelenítése a session-ből
    document.getElementById('userName').textContent = user.name || 'N/A';
    document.getElementById('userEmail').textContent = user.email || 'N/A';
    document.getElementById('userRole').textContent = translateRole(user.role) || 'N/A';

    // Részletes adatok lekérése a backendről
    try {
        const result = await UserAPI.getById(user.user_id);
        
        if (result.success) {
            const userData = result.data;
            document.getElementById('userName').textContent = userData.name || 'N/A';
            document.getElementById('userEmail').textContent = userData.email || 'N/A';
            document.getElementById('userPhone').textContent = userData.phone || 'Nincs megadva';
            document.getElementById('userAddress').textContent = userData.address || 'Nincs megadva';
            document.getElementById('userRole').textContent = translateRole(userData.role) || 'N/A';
            document.getElementById('userCreatedAt').textContent = formatDate(userData.created_at);
        }
    } catch (error) {
        console.error('Profil betöltési hiba:', error);
    }
}

// Felhasználó rendeléseinek betöltése
async function loadUserOrders() {
    const userId = Session.getUserId();
    const ordersContainer = document.getElementById('ordersContainer');
    
    if (!ordersContainer) return;

    ordersContainer.innerHTML = '<p>Rendelések betöltése...</p>';

    try {
        const result = await OrdersAPI.getByUser(userId);
        
        if (result.success && Array.isArray(result.data)) {
            if (result.data.length === 0) {
                ordersContainer.innerHTML = '<p class="text-muted">Még nincsenek rendeléseid.</p>';
                return;
            }

            let html = `
                <table class="table table-dark table-striped">
                    <thead>
                        <tr>
                            <th>Rendelés #</th>
                            <th>Dátum</th>
                            <th>Összeg</th>
                            <th>Státusz</th>
                            <th>Részletek</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            // Rendelések fordított sorrendben (legújabb elöl)
            const sortedOrders = result.data.sort((a, b) => b.order_id - a.order_id);

            for (const order of sortedOrders) {
                const statusClass = getStatusClass(order.status);
                html += `
                    <tr>
                        <td>#${order.order_id}</td>
                        <td>${formatDate(order.created_at)}</td>
                        <td>${formatPrice(order.total_price)}</td>
                        <td><span class="badge ${statusClass}">${translateStatus(order.status)}</span></td>
                        <td>
                            <button class="btn btn-sm btn-outline-warning" onclick="showOrderDetails(${order.order_id})">
                                Részletek
                            </button>
                        </td>
                    </tr>
                `;
            }

            html += '</tbody></table>';
            ordersContainer.innerHTML = html;
        } else {
            ordersContainer.innerHTML = '<p class="text-danger">Hiba a rendelések betöltésekor.</p>';
        }
    } catch (error) {
        console.error('Rendelések betöltési hiba:', error);
        ordersContainer.innerHTML = '<p class="text-danger">Hálózati hiba történt.</p>';
    }
}

// Státusz badge osztály
function getStatusClass(status) {
    const classMap = {
        'pending': 'bg-warning text-dark',
        'preparing': 'bg-info',
        'delivering': 'bg-primary',
        'completed': 'bg-success',
        'cancelled': 'bg-danger'
    };
    return classMap[status] || 'bg-secondary';
}

// Rendelés részleteinek megjelenítése
async function showOrderDetails(orderId) {
    try {
        // Rendelési tételek lekérése
        const itemsResult = await OrderItemsAPI.getByOrder(orderId);
        
        if (itemsResult.success && Array.isArray(itemsResult.data)) {
            let detailsHtml = '<h5>Rendelési tételek:</h5><ul>';
            
            for (const item of itemsResult.data) {
                // Étel nevének lekérése
                const dishResult = await DishesAPI.getById(item.dish_id);
                const dishName = dishResult.success ? dishResult.data.name : `Étel #${item.dish_id}`;
                
                detailsHtml += `
                    <li>${dishName} - ${item.quantity} db - ${formatPrice(item.price)}</li>
                `;
            }
            
            detailsHtml += '</ul>';

            // Fizetés lekérése
            const paymentResult = await PaymentsAPI.getByOrder(orderId);
            if (paymentResult.success) {
                detailsHtml += `
                    <hr>
                    <p><strong>Fizetési mód:</strong> ${translatePaymentMethod(paymentResult.data.method)}</p>
                    <p><strong>Fizetés státusza:</strong> ${translateStatus(paymentResult.data.status)}</p>
                `;
            }

            // Modal vagy alert megjelenítése
            alert(detailsHtml.replace(/<[^>]*>/g, '\n').replace(/&nbsp;/g, ' '));
        }
    } catch (error) {
        console.error('Rendelés részletek hiba:', error);
        alert('Hiba a rendelés részleteinek betöltésekor.');
    }
}

// Fizetési mód fordítása
function translatePaymentMethod(method) {
    const methodMap = {
        'card': 'Bankkártya',
        'cash': 'Készpénz',
        'paypal': 'PayPal'
    };
    return methodMap[method] || method;
}

// Profil szerkesztése
async function editProfile() {
    const user = Session.getUser();
    
    const newName = prompt('Új név:', user.name);
    if (newName === null) return;
    
    const newPhone = prompt('Új telefonszám:', user.phone || '');
    if (newPhone === null) return;
    
    const newAddress = prompt('Új cím:', user.address || '');
    if (newAddress === null) return;

    try {
        const result = await UserAPI.update(user.user_id, {
            name: newName || user.name,
            phone: newPhone,
            address: newAddress
        });

        if (result.success) {
            // Session frissítése
            Session.login({
                ...user,
                name: newName || user.name,
                phone: newPhone,
                address: newAddress
            });
            
            alert('Profil sikeresen frissítve!');
            loadUserProfile();
        } else {
            alert('Hiba: ' + (result.data.message || 'Ismeretlen hiba'));
        }
    } catch (error) {
        console.error('Profil frissítési hiba:', error);
        alert('Hálózati hiba történt.');
    }
}

console.log('Profile.js betöltve');
