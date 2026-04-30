const ROLE_HIERARCHY = {
    'customer': 0,
    'admin': 1,
    'restaurant_owner': 2
};

function getCurrentRoleLevel() {
    const role = Session.getUserRole();
    return ROLE_HIERARCHY[role] || 0;
}

function isOwner() {
    return Session.getUserRole() === 'restaurant_owner';
}

function isAdmin() {
    return Session.getUserRole() === 'admin';
}

// Ellenőrzés: jogosult-e egy adott user-t kezelni
function canManageUser(targetRole) {
    const myLevel = getCurrentRoleLevel();
    const targetLevel = ROLE_HIERARCHY[targetRole] || 0;
    return myLevel > targetLevel;
}


function canManageRestaurantsAndDishes() {
    return Session.getUserRole() === 'restaurant_owner';
}

// Belépési jogosultság ellenőrzés
(function() {
    if (!Session.isLoggedIn()) {
        alert('Kérlek jelentkezz be!');
        window.location.href = 'login.html';
        return;
    }

    const roleLevel = getCurrentRoleLevel();
    if (roleLevel < 1) {
        alert('Nincs jogosultságod az admin felület eléréséhez!');
        window.location.href = 'index.html';
        return;
    }
})();


function confirmLogout() {
    // Megerősítő modal létrehozása ha még nincs
    if (!document.getElementById('logoutConfirmModal')) {
        const modalHtml = `
            <div class="modal fade" id="logoutConfirmModal" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content" style="background: #1e1e1e; border: 1px solid #333;">
                        <div class="modal-header" style="border-bottom: 1px solid #333;">
                            <h5 class="modal-title" style="color: #fff;">
                                <span style="margin-right: 8px;">🚪</span>Kijelentkezés
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body" style="color: #ccc;">
                            <p>Biztosan ki szeretnél jelentkezni?</p>
                        </div>
                        <div class="modal-footer" style="border-top: 1px solid #333;">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Mégse</button>
                            <button type="button" class="btn btn-danger" id="confirmLogoutBtn">Kijelentkezés</button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', modalHtml);

        // Kijelentkezés gomb eseménykezelő
        document.getElementById('confirmLogoutBtn').addEventListener('click', function() {
            Session.logout();
            window.location.href = 'login.html';
        });
    }

    // Modal megjelenítése
    const modal = new bootstrap.Modal(document.getElementById('logoutConfirmModal'));
    modal.show();
}

// Kijelentkezés gombok eseménykezelőinek beállítása
document.addEventListener('DOMContentLoaded', function() {
    // Minden logout gombra feliratkozás
    document.querySelectorAll('.logout-btn, [data-action="logout"], #logoutBtn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            confirmLogout();
        });
    });
});