//Regisztáció js

document.addEventListener('DOMContentLoaded', function() {
    // Ha már be van jelentkezve, átirányítás a főoldalra
    if (typeof Session !== 'undefined' && Session.isLoggedIn()) {
        window.location.href = 'index.html';
        return;
    }

    const registrationForm = document.getElementById('registrationForm');
    const errorMessage = document.getElementById('errorMessage');
    const successMessage = document.getElementById('successMessage');

    registrationForm.addEventListener('submit', async function(e) {
        e.preventDefault();

        // Üzenetek elrejtése
        errorMessage.style.display = 'none';
        errorMessage.textContent = '';
        successMessage.style.display = 'none';
        successMessage.textContent = '';

        // Adatok beolvasása
        const name = document.getElementById('name').value.trim();
        const username = document.getElementById('username').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const password = document.getElementById('password').value;
        const passwordConfirm = document.getElementById('password-confirm').value;

        // Validáció
        if (!name) {
            errorMessage.textContent = 'A teljes név megadása kötelező!';
            errorMessage.style.display = 'block';
            return;
        }

        if (!username) {
            errorMessage.textContent = 'A felhasználónév megadása kötelező!';
            errorMessage.style.display = 'block';
            return;
        }

        if (!email) {
            errorMessage.textContent = 'Az email cím megadása kötelező!';
            errorMessage.style.display = 'block';
            return;
        }

        if (!password || !passwordConfirm) {
            errorMessage.textContent = 'A jelszó megadása kötelező!';
            errorMessage.style.display = 'block';
            return;
        }

        // Jelszó egyezés ellenőrzése
        if (password !== passwordConfirm) {
            errorMessage.textContent = 'A jelszavak nem egyeznek!';
            errorMessage.style.display = 'block';
            return;
        }

        // Jelszó erősség ellenőrzése (frontend)
        if (password.length < 8) {
            errorMessage.textContent = 'A jelszónak minimum 8 karakter hosszúnak kell lennie!';
            errorMessage.style.display = 'block';
            return;
        }

        if (!/[A-Z]/.test(password)) {
            errorMessage.textContent = 'A jelszónak tartalmaznia kell legalább egy nagybetűt!';
            errorMessage.style.display = 'block';
            return;
        }

        if (!/[!@#$%^&*()_+\-=\[\]{}|;':",./<>?`~]/.test(password)) {
            errorMessage.textContent = 'A jelszónak tartalmaznia kell legalább egy speciális karaktert!';
            errorMessage.style.display = 'block';
            return;
        }

        // Telefonszám validáció (magyar formátum: +36 XX XXX XXXX vagy 06 XX XXX XXXX)
        const phoneRegex = /^(\+36|06)\s?(20|30|31|50|70)\s?[0-9]{3}\s?[0-9]{4}$/;
        
        if (!phoneRegex.test(phone)) {
            errorMessage.textContent = 'Kérlek adj meg egy érvényes magyar telefonszámot! Formátum: +36 50 111 1111 vagy 06 50 111 1111';
            errorMessage.style.display = 'block';
            return;
        }

        // Email formátum ellenőrzése
        const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
        if (!emailRegex.test(email)) {
            errorMessage.textContent = 'Kérlek adj meg egy érvényes email címet!';
            errorMessage.style.display = 'block';
            return;
        }

        // Gomb letiltása
        const registerBtn = document.getElementById('registerBtn');
        registerBtn.disabled = true;
        registerBtn.textContent = 'Regisztráció...';

        try {
            // API hívás
            const result = await UserAPI.register({
                name: name,
                username: username,  
                email: email,
                password: password,
                phone: phone,
                role: 'customer'
            });

            if (result.success) {
                // Sikeres regisztráció
                successMessage.textContent = 'Sikeres regisztráció! Átirányítás a bejelentkezéshez...';
                successMessage.style.display = 'block';

                // Átirányítás 2 mp után
                setTimeout(() => {
                    window.location.href = 'login.html';
                }, 2000);
            } else {
                // Sikertelen regisztráció
                errorMessage.textContent = result.data.message || 'Hiba történt a regisztráció során!';
                errorMessage.style.display = 'block';
                registerBtn.disabled = false;
                registerBtn.textContent = 'Regisztrálok';
            }
        } catch (error) {
            console.error('Regisztrációs hiba:', error);
            errorMessage.textContent = 'Hálózati hiba történt. Próbáld újra később!';
            errorMessage.style.display = 'block';
            registerBtn.disabled = false;
            registerBtn.textContent = 'Regisztrálok';
        }
    });
});

console.log('Registration.js betöltve');