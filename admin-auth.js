/**
 * KLSZ Faloda - Admin jogosultság ellenőrzés
 * Hierarchia: customer < admin < restaurant_owner
 * 
 * - restaurant_owner: mindent lát és kezel (admin + customer felhasználókat is)
 *                     + ÉS CSAK Ő törölhet/módosíthat éttermeket és ételeket
 * - admin: csak customer felhasználókat kezelheti, NEM módosíthat éttermeket/ételeket
 * - customer: NEM férhet hozzá az admin felülethez
 */

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

/**
 * Ellenőrzés: jogosult-e éttermeket/ételeket kezelni
 * CSAK restaurant_owner szerepkörű felhasználók!
 */
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
