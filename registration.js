//regisztrációs logika

// Ha már be van jelentkezve, átirányítjuk
if (isLoggedIn()) {
    window.location.href = 'profile.html';
}

document.getElementById('registrationForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const username = document.getElementById('username').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const password = document.getElementById('password').value;
    const passwordConfirm = document.getElementById('password-confirm').value;
    const registerBtn = document.getElementById('registerBtn');
    const errorMessage = document.getElementById('errorMessage');
    const successMessage = document.getElementById('successMessage');
    
    // Reset üzenetek
    errorMessage.style.display = 'none';
    successMessage.style.display = 'none';
    
    // Jelszó egyezés ellenőrzése
    if (password !== passwordConfirm) {
        errorMessage.textContent = 'A két jelszó nem egyezik!';
        errorMessage.style.display = 'block';
        return;
    }
    
    // Frontend jelszó validáció
    const passwordErrors = validatePassword(password);
    if (passwordErrors.length > 0) {
        errorMessage.textContent = 'Jelszó hibák: ' + passwordErrors.join(', ');
        errorMessage.style.display = 'block';
        return;
    }
    
    // Gomb letiltása
    registerBtn.disabled = true;
    registerBtn.textContent = 'Regisztráció...';
    
    try {
        const result = await register(username, email, password, phone);
        
        if (result.status === 'success') {
            successMessage.textContent = 'Sikeres regisztráció! Átirányítás a bejelentkezéshez...';
            successMessage.style.display = 'block';
            
            setTimeout(() => {
                window.location.href = 'login.html';
            }, 2000);
        } else {
            errorMessage.textContent = result.message || 'Hiba történt a regisztráció során.';
            errorMessage.style.display = 'block';
            registerBtn.disabled = false;
            registerBtn.textContent = 'Regisztrálok';
        }
    } catch (error) {
        errorMessage.textContent = 'Kapcsolódási hiba. Kérlek próbáld újra később.';
        errorMessage.style.display = 'block';
        registerBtn.disabled = false;
        registerBtn.textContent = 'Regisztrálok';
    }
});
