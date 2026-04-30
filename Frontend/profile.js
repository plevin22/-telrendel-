let currentUserData = null;

document.addEventListener('DOMContentLoaded', function() {
    // Bejelentkezés ellenőrzése
    if (!Session.isLoggedIn()) {
        window.location.href = 'login.html';
        return;
    }

    // Navigáció frissítése
    if (typeof updateNavigation === 'function') {
        updateNavigation();
    }

    // Felhasználói adatok betöltése
    loadUserProfile();

    // Rendelések betöltése
    loadUserOrders();

    // Modal eseménykezelő - adatok betöltése megnyitáskor
    const editProfileModal = document.getElementById('editProfileModal');
    if (editProfileModal) {
        editProfileModal.addEventListener('show.bs.modal', function() {
            populateEditForm();
        });
    }
});

function showToast(message, type = 'info') {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = `custom-toast ${type}`;
    
    let icon = '';
    switch(type) {
        case 'success':
            icon = '✓';
            break;
        case 'error':
            icon = '✕';
            break;
        default:
            icon = 'ℹ';
    }
    
    toast.innerHTML = `<span>${icon}</span><span>${message}</span>`;
    container.appendChild(toast);

    // Automatikus eltüntetés 3 másodperc után
    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease forwards';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

async function loadUserProfile() {
    const user = Session.getUser();
    
    // Alapadatok megjelenítése a session-ból
    document.getElementById('userName').textContent = user.name || 'N/A';
    document.getElementById('userEmail').textContent = user.email || 'N/A';
    document.getElementById('userRole').textContent = translateRole(user.role) || 'N/A';

    // Részletes adatok lekérése a backendről
    try {
        const result = await UserAPI.getById(user.user_id);
        
        if (result.success) {
            currentUserData = result.data;
            
            // Profil adatok megjelenítése
            document.getElementById('userName').textContent = currentUserData.name || 'N/A';
            document.getElementById('userEmail').textContent = currentUserData.email || 'N/A';
            document.getElementById('userPhone').textContent = currentUserData.phone || 'Nincs megadva';
            document.getElementById('userRole').textContent = translateRole(currentUserData.role) || 'N/A';
            document.getElementById('userCreatedAt').textContent = formatDate(currentUserData.created_at);
        }
    } catch (error) {
        console.error('Profil betöltési hiba:', error);
        showToast('Hiba a profil betöltésekor', 'error');
    }
}

function populateEditForm() {
    if (currentUserData) {
        document.getElementById('editName').value = currentUserData.name || '';
        document.getElementById('editUsername').value = currentUserData.username || '';
        document.getElementById('editEmail').value = currentUserData.email || '';
        document.getElementById('editPhone').value = currentUserData.phone || '';
    } else {
        const user = Session.getUser();
        document.getElementById('editName').value = user.name || '';
        document.getElementById('editUsername').value = user.username || '';
        document.getElementById('editEmail').value = user.email || '';
        document.getElementById('editPhone').value = user.phone || '';
    }
}


async function saveProfile() {
    const saveBtn = document.getElementById('saveProfileBtn');
    const originalText = saveBtn.innerHTML;
    
    // Validáció
    const newName = document.getElementById('editName').value.trim();
    const newUsername = document.getElementById('editUsername').value.trim();
    const newPhone = document.getElementById('editPhone').value.trim();
    
    if (!newName) {
        showToast('A név megadása kötelező!', 'error');
        document.getElementById('editName').focus();
        return;
    }

    if (!newUsername) {
        showToast('A felhasználónév megadása kötelező!', 'error');
        document.getElementById('editUsername').focus();
        return;
    }

    // Gomb letiltása és spinner
    saveBtn.disabled = true;
    saveBtn.innerHTML = '<span class="btn-spinner"></span>Mentés...';

    try {
        // Felhasználó adatainak lekérése a frissítéshez
        const user = Session.getUser();
        
        // Az UpdateUser stored procedure-nak az összes mező kell
        // Ezért először lekérjük az aktuális adatokat, majd frissítjük
        const updateData = {
            name: newName,
            username: newUsername,
            email: currentUserData?.email || user.email,
            password: currentUserData?.password || user.password, // Megtartjuk a jelenlegi jelszót
            phone: newPhone || null,
            role: currentUserData?.role || user.role,
            banned: currentUserData?.banned || 0
        };

        const result = await UserAPI.update(user.user_id, updateData);

        if (result.success) {
            // Session frissítése az új adatokkal
            const updatedUser = {
                ...user,
                name: newName,
                username: newUsername,
                phone: newPhone
            };
            Session.login(updatedUser);
            
            // Lokális adatok frissítése
            if (currentUserData) {
                currentUserData.name = newName;
                currentUserData.username = newUsername;
                currentUserData.phone = newPhone;
            }
            
            // Modal bezárása
            const modal = bootstrap.Modal.getInstance(document.getElementById('editProfileModal'));
            modal.hide();
            
            // Sikeres üzenet
            showToast('Profil sikeresen frissítve!', 'success');
            
            // Profil újratöltése
            loadUserProfile();
        } else {
            showToast('Hiba: ' + (result.data?.message || 'Ismeretlen hiba'), 'error');
        }
    } catch (error) {
        console.error('Profil frissítési hiba:', error);
        showToast('Hálózati hiba történt a mentés során.', 'error');
    } finally {
        // Gomb visszaállítása
        saveBtn.disabled = false;
        saveBtn.innerHTML = originalText;
    }
}


async function loadUserOrders() {
    const userId = Session.getUserId();
    const ordersContainer = document.getElementById('ordersContainer');
    
    if (!ordersContainer) return;

    ordersContainer.innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-warning" role="status">
                <span class="visually-hidden">Betöltés...</span>
            </div>
            <p class="mt-2">Rendelések betöltése...</p>
        </div>
    `;

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
                            <th>Értékelés</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            // Rendelések fordított sorrendben (legújabb elöl)
            const sortedOrders = result.data.sort((a, b) => b.order_id - a.order_id);

            // Felhasználó értékeléseinek lekérése
            let userReviews = [];
            try {
                const reviewsResult = await ReviewsAPI.getByUser(userId);
                if (reviewsResult.success && Array.isArray(reviewsResult.data)) {
                    userReviews = reviewsResult.data;
                }
            } catch (e) {
                console.error('Értékelések lekérési hiba:', e);
            }

            // Már értékelt rendelés ID-k gyűjtése
            const reviewedOrderIds = userReviews.map(r => r.order_id);

            for (const order of sortedOrders) {
                const statusClass = getStatusClass(order.status);
                
                // Értékelés gomb logika
                let reviewBtn = '';
                if (order.status === 'completed') {
                    if (reviewedOrderIds.includes(order.order_id)) {
                        // Már értékelve
                        reviewBtn = '<span class="badge bg-success">Értékelve ✓</span>';
                    } else {
                        // Értékelhető
                        reviewBtn = `<button class="btn btn-sm btn-outline-warning" onclick="goToReview(${order.order_id})">⭐ Értékelés</button>`;
                    }
                } else {
                    reviewBtn = '<span class="text-muted" style="font-size: 0.85rem;">—</span>';
                }

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
                        <td>${reviewBtn}</td>
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

async function showOrderDetails(orderId) {
    // Modal megnyitása
    const modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
    modal.show();
    
    // Cím frissítése
    document.getElementById('orderIdTitle').textContent = `#${orderId}`;
    
    // Betöltés jelzése
    const contentDiv = document.getElementById('orderDetailsContent');
    contentDiv.innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-warning" role="status">
                <span class="visually-hidden">Betöltés...</span>
            </div>
            <p class="mt-2">Rendelés adatainak betöltése...</p>
        </div>
    `;

    try {
        // Rendelés alapadatainak lekérése
        let orderData = null;
        try {
            const orderResult = await OrdersAPI.getById(orderId);
            if (orderResult.success) {
                orderData = orderResult.data;
            }
        } catch (e) {
            console.error('Rendelés lekérési hiba:', e);
        }

        // Rendelési tételek lekérése
        const itemsResult = await OrderItemsAPI.getByOrder(orderId);
        
        let itemsHtml = '';
        let itemCount = 0;
        
        if (itemsResult.success && Array.isArray(itemsResult.data)) {
            for (const item of itemsResult.data) {
                // Étel nevének lekérése
                let dishName = `Étel #${item.dish_id}`;
                try {
                    const dishResult = await DishesAPI.getById(item.dish_id);
                    if (dishResult.success) {
                        dishName = dishResult.data.name;
                    }
                } catch (e) {
                    console.error('Étel lekérési hiba:', e);
                }
                
                itemCount += item.quantity;
                const unitPrice = item.price / item.quantity;
                
                itemsHtml += `
                    <div class="order-detail-item">
                        <div>
                            <div class="order-detail-name">${dishName}</div>
                            <div class="order-detail-quantity">${item.quantity} db × ${formatPrice(unitPrice)}</div>
                        </div>
                        <div class="order-detail-price">${formatPrice(item.price)}</div>
                    </div>
                `;
            }
        }
        
        // Fizetés lekérése
        let paymentMethod = null;
        let paymentStatus = null;
        try {
            const paymentResult = await PaymentsAPI.getByOrder(orderId);
            if (paymentResult.success && paymentResult.data) {
                paymentMethod = paymentResult.data.method;
                paymentStatus = paymentResult.data.status;
            }
        } catch (e) {
            console.error('Fizetés lekérési hiba:', e);
        }

        // Adatok az orderData-ból
        const totalPrice = orderData ? orderData.total_price : 0;
        const status = orderData ? orderData.status : 'pending';
        const createdAt = orderData ? orderData.created_at : null;
        const deliveryAddress = orderData ? orderData.delivery_address : null;

        // Teljes tartalom összeállítása
        contentDiv.innerHTML = `
            <div class="mb-3">
                <div class="order-info-row">
                    <span class="order-info-label">Rendelés dátuma:</span>
                    <span>${createdAt ? formatDate(createdAt) : 'N/A'}</span>
                </div>
                <div class="order-info-row">
                    <span class="order-info-label">Státusz:</span>
                    <span class="badge ${getStatusClass(status)}">${translateStatus(status)}</span>
                </div>
                ${deliveryAddress ? `
                <div class="order-info-row">
                    <span class="order-info-label">Szállítási cím:</span>
                    <span>${deliveryAddress}</span>
                </div>
                ` : ''}
                ${paymentMethod ? `
                <div class="order-info-row">
                    <span class="order-info-label">Fizetési mód:</span>
                    <span>${translatePaymentMethod(paymentMethod)}</span>
                </div>
                ` : ''}
                ${paymentStatus ? `
                <div class="order-info-row">
                    <span class="order-info-label">Fizetés státusza:</span>
                    <span class="badge ${getPaymentStatusClass(paymentStatus)}">${translatePaymentStatus(paymentStatus)}</span>
                </div>
                ` : ''}
            </div>
            
            <div class="order-summary">
                <h6 class="mb-3" style="color: #d4a528;">Rendelt tételek (${itemCount} db)</h6>
                ${itemsHtml || '<p class="text-muted">Nincsenek tételek.</p>'}
                <div class="order-summary-row order-summary-total">
                    <span>Végösszeg:</span>
                    <span class="order-detail-price">${formatPrice(totalPrice)}</span>
                </div>
            </div>
        `;
        
    } catch (error) {
        console.error('Rendelés részletek hiba:', error);
        contentDiv.innerHTML = `
            <div class="text-center py-4">
                <p class="text-danger">Hiba a rendelés részleteinek betöltésekor.</p>
                <button class="btn btn-outline-warning mt-2" onclick="showOrderDetails(${orderId})">
                    Újrapróbálás
                </button>
            </div>
        `;
    }
}


function translatePaymentMethod(method) {
    const methodMap = {
        'card': 'Bankkártya',
        'cash': 'Készpénz',
        'paypal': 'PayPal'
    };
    return methodMap[method] || method;
}


function translatePaymentStatus(status) {
    const statusMap = {
        'pending': 'Függőben',
        'paid': 'Kifizetve',
        'completed': 'Sikeres',
        'failed': 'Sikertelen',
        'refunded': 'Visszatérítve'
    };
    return statusMap[status] || status;
}


function getPaymentStatusClass(status) {
    const classMap = {
        'pending': 'bg-warning text-dark',
        'paid': 'bg-success',
        'completed': 'bg-success',
        'failed': 'bg-danger',
        'refunded': 'bg-info'
    };
    return classMap[status] || 'bg-secondary';
}


function translateRole(role) {
    const roleMap = {
        'customer': 'Vásárló',
        'admin': 'Adminisztrátor',
        'restaurant_owner': 'Étterem tulajdonos'
    };
    return roleMap[role] || role;
}


function translateStatus(status) {
    const statusMap = {
        'pending': 'Függőben',
        'preparing': 'Készítés alatt',
        'delivering': 'Kiszállítás alatt',
        'completed': 'Teljesítve',
        'cancelled': 'Törölve'
    };
    return statusMap[status] || status;
}


function formatDate(dateString) {
    if (!dateString) return 'N/A';
    
    try {
        const date = new Date(dateString);
        return date.toLocaleDateString('hu-HU', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    } catch (e) {
        return dateString;
    }
}

function formatPrice(price) {
    if (price === null || price === undefined) return '0 Ft';
    return new Intl.NumberFormat('hu-HU').format(price) + ' Ft';
}


function goToReview(orderId) {
    window.location.href = `reviews.html?order_id=${orderId}`;
}


function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    if (input.type === 'password') {
        input.type = 'text';
    } else {
        input.type = 'password';
    }
}


async function changePassword() {
    const oldPassword = document.getElementById('oldPassword').value.trim();
    const newPassword = document.getElementById('newPassword').value.trim();
    const confirmPassword = document.getElementById('confirmPassword').value.trim();
    const changeBtn = document.getElementById('changePasswordBtn');
    const originalText = changeBtn.innerHTML;

    // Validáció
    if (!oldPassword) {
        showToast('A jelenlegi jelszó megadása kötelező!', 'error');
        document.getElementById('oldPassword').focus();
        return;
    }

    if (!newPassword) {
        showToast('Az új jelszó megadása kötelező!', 'error');
        document.getElementById('newPassword').focus();
        return;
    }

    if (newPassword.length < 8) {
        showToast('Az új jelszónak minimum 8 karakter hosszúnak kell lennie!', 'error');
        document.getElementById('newPassword').focus();
        return;
    }

    // Nagybetű ellenőrzése
    if (!/[A-Z]/.test(newPassword)) {
        showToast('Az új jelszónak tartalmaznia kell legalább egy nagybetűt!', 'error');
        document.getElementById('newPassword').focus();
        return;
    }

    // Speciális karakter ellenőrzése
    if (!/[!@#$%^&*()_+\-=\[\]{}|;':",./<>?`~]/.test(newPassword)) {
        showToast('Az új jelszónak tartalmaznia kell legalább egy speciális karaktert!', 'error');
        document.getElementById('newPassword').focus();
        return;
    }

    if (newPassword !== confirmPassword) {
        showToast('Az új jelszavak nem egyeznek!', 'error');
        document.getElementById('confirmPassword').focus();
        return;
    }

    if (oldPassword === newPassword) {
        showToast('Az új jelszó nem egyezhet a régivel!', 'error');
        document.getElementById('newPassword').focus();
        return;
    }

    // Gomb letiltása
    changeBtn.disabled = true;
    changeBtn.innerHTML = '<span class="btn-spinner"></span>Feldolgozás...';

    try {
        const userId = Session.getUserId();
        
        const response = await fetch(`${API_BASE_URL}/users/ChangeUserPassword/${userId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                old_password: oldPassword,
                new_password: newPassword
            })
        });

        const result = await response.json();

        if (response.ok && result.status === 'success') {
            // Modal bezárása
            const modal = bootstrap.Modal.getInstance(document.getElementById('changePasswordModal'));
            modal.hide();

            // Form ürítése
            document.getElementById('changePasswordForm').reset();

            // Sikeres üzenet
            showToast('Jelszó sikeresen megváltoztatva!', 'success');
        } else {
            showToast(result.message || 'Hiba történt a jelszó változtatása során.', 'error');
        }
    } catch (error) {
        console.error('Jelszó változtatási hiba:', error);
        showToast('Hálózati hiba történt.', 'error');
    } finally {
        // Gomb visszaállítása
        changeBtn.disabled = false;
        changeBtn.innerHTML = originalText;
    }
}

console.log('Profile.js betöltve');