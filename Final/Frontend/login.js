

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


async function forgotPassword() {
    const email = document.getElementById('forgotEmail').value.trim();
    const forgotBtn = document.getElementById('forgotPasswordBtn');
    const errorDiv = document.getElementById('forgotPasswordError');
    const successDiv = document.getElementById('forgotPasswordSuccess');
    const originalText = forgotBtn.innerHTML;

    // Üzenetek elrejtése
    errorDiv.style.display = 'none';
    successDiv.style.display = 'none';

    // Validáció
    if (!email) {
        errorDiv.textContent = 'Az email cím megadása kötelező!';
        errorDiv.style.display = 'block';
        document.getElementById('forgotEmail').focus();
        return;
    }

    // Email formátum ellenőrzése
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        errorDiv.textContent = 'Érvénytelen email formátum!';
        errorDiv.style.display = 'block';
        document.getElementById('forgotEmail').focus();
        return;
    }

    // Gomb letiltása
    forgotBtn.disabled = true;
    forgotBtn.innerHTML = 'Küldés...';

    try {
        const response = await fetch(`${API_BASE_URL}/password/ForgotUserPassword`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email: email })
        });

        const result = await response.json();

        if (response.ok && result.status === 'success') {
            successDiv.textContent = result.message || 'Ha az email cím létezik, hamarosan kapsz egy visszaállító linket.';
            successDiv.style.display = 'block';
            
            // Form ürítése
            document.getElementById('forgotPasswordForm').reset();

            // Modal bezárása 3 mp után
            setTimeout(() => {
                const modal = bootstrap.Modal.getInstance(document.getElementById('forgotPasswordModal'));
                if (modal) {
                    modal.hide();
                }
                successDiv.style.display = 'none';
            }, 3000);
        } else {
            errorDiv.textContent = result.message || 'Hiba történt a feldolgozás során.';
            errorDiv.style.display = 'block';
        }
    } catch (error) {
        console.error('Elfelejtett jelszó hiba:', error);
        errorDiv.textContent = 'Hálózati hiba történt.';
        errorDiv.style.display = 'block';
    } finally {
        // Gomb visszaállítása
        forgotBtn.disabled = false;
        forgotBtn.innerHTML = originalText;
    }
}

console.log('Login.js betöltve');
