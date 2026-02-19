/**
 * KLSZ Faloda - Bejelentkezés oldal JavaScript
 */

document.addEventListener('DOMContentLoaded', function() {
    // Ha már be van jelentkezve, átirányítás a főoldalra
    if (Session.isLoggedIn()) {
        window.location.href = 'index.html';
        return;
    }

    const loginForm = document.getElementById('loginForm');
    const errorMessage = document.getElementById('errorMessage');
    const successMessage = document.getElementById('successMessage');

    loginForm.addEventListener('submit', async function(e) {
        e.preventDefault();

        // Üzenetek elrejtése
        errorMessage.style.display = 'none';
        successMessage.style.display = 'none';

        // Adatok beolvasása
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value;

        // Validáció
        if (!email || !password) {
            errorMessage.textContent = 'Kérlek töltsd ki az összes mezőt!';
            errorMessage.style.display = 'block';
            return;
        }

        // Gomb letiltása
        const loginBtn = document.getElementById('loginBtn');
        loginBtn.disabled = true;
        loginBtn.textContent = 'Bejelentkezés...';

        try {
            // API hívás
            const result = await UserAPI.login(email, password);

            if (result.success) {
                // Sikeres bejelentkezés
                successMessage.textContent = 'Sikeres bejelentkezés! Átirányítás...';
                successMessage.style.display = 'block';

                // Session mentése
                Session.login({
                    user_id: result.data.user_id,
                    name: result.data.name,
                    email: result.data.email,
                    role: result.data.role
                });

                // Átirányítás 1.5 mp után
                setTimeout(() => {
                    // Admin átirányítás az admin oldalra
                    if (result.data.role === 'admin') {
                        window.location.href = 'index.html';
                    } else {
                        window.location.href = 'index.html';
                    }
                }, 1500);
            } else {
                // Sikertelen bejelentkezés
                errorMessage.textContent = result.data.message || 'Hibás email vagy jelszó!';
                errorMessage.style.display = 'block';
                loginBtn.disabled = false;
                loginBtn.textContent = 'Bejelentkezés';
            }
        } catch (error) {
            console.error('Bejelentkezési hiba:', error);
            errorMessage.textContent = 'Hálózati hiba történt. Próbáld újra később!';
            errorMessage.style.display = 'block';
            loginBtn.disabled = false;
            loginBtn.textContent = 'Bejelentkezés';
        }
    });
});

console.log('Login.js betöltve');
