//login logika

// Ha már be van jelentkezve, átirányítjuk
if (isLoggedIn()) {
    window.location.href = 'profile.html';
}

document.getElementById('loginForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const loginBtn = document.getElementById('loginBtn');
    const errorMessage = document.getElementById('errorMessage');
    const successMessage = document.getElementById('successMessage');
    
    // Reset üzenetek
    errorMessage.style.display = 'none';
    successMessage.style.display = 'none';
    
    // Gomb letiltása
    loginBtn.disabled = true;
    loginBtn.textContent = 'Bejelentkezés...';
    
    try {
        const result = await login(email, password);
        
        if (result.status === 'success') {
            successMessage.textContent = 'Sikeres bejelentkezés! Átirányítás...';
            successMessage.style.display = 'block';
            
            setTimeout(() => {
                window.location.href = 'index.html';
            }, 1500);
        } else {
            errorMessage.textContent = result.message || 'Hiba történt a bejelentkezés során.';
            errorMessage.style.display = 'block';
            loginBtn.disabled = false;
            loginBtn.textContent = 'Bejelentkezés';
        }
    } catch (error) {
        errorMessage.textContent = 'Kapcsolódási hiba. Kérlek próbáld újra később.';
        errorMessage.style.display = 'block';
        loginBtn.disabled = false;
        loginBtn.textContent = 'Bejelentkezés';
    }
});
