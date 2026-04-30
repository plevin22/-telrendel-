// Token kiolvasása az URL-ből
        const urlParams = new URLSearchParams(window.location.search);
        const token = urlParams.get('token');

        document.addEventListener('DOMContentLoaded', async function() {
            const loadingState = document.getElementById('loadingState');
            const invalidTokenState = document.getElementById('invalidTokenState');
            const resetFormState = document.getElementById('resetFormState');

            if (!token) {
                loadingState.style.display = 'none';
                invalidTokenState.style.display = 'block';
                return;
            }

            // Token validálása
            try {
                const response = await fetch(`${API_BASE_URL}/password/ValidateToken/${token}`);
                const result = await response.json();

                loadingState.style.display = 'none';

                if (result.valid) {
                    resetFormState.style.display = 'block';
                } else {
                    invalidTokenState.style.display = 'block';
                }
            } catch (error) {
                console.error('Token validálási hiba:', error);
                loadingState.style.display = 'none';
                invalidTokenState.style.display = 'block';
            }

            // Form submit
            const resetForm = document.getElementById('resetPasswordForm');
            resetForm.addEventListener('submit', async function(e) {
                e.preventDefault();
                await resetPassword();
            });
        });

        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            input.type = input.type === 'password' ? 'text' : 'password';
        }

        async function resetPassword() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const resetBtn = document.getElementById('resetBtn');
            const errorMessage = document.getElementById('errorMessage');
            const successMessage = document.getElementById('successMessage');
            const originalText = resetBtn.innerHTML;

            // Üzenetek elrejtése
            errorMessage.style.display = 'none';
            successMessage.style.display = 'none';

            // Validáció
            if (!newPassword) {
                errorMessage.textContent = 'Az új jelszó megadása kötelező!';
                errorMessage.style.display = 'block';
                return;
            }

            if (newPassword.length < 8) {
                errorMessage.textContent = 'A jelszónak minimum 8 karakter hosszúnak kell lennie!';
                errorMessage.style.display = 'block';
                return;
            }

            if (!/[A-Z]/.test(newPassword)) {
                errorMessage.textContent = 'A jelszónak tartalmaznia kell legalább egy nagybetűt!';
                errorMessage.style.display = 'block';
                return;
            }

            if (!/[!@#$%^&*()_+\-=\[\]{}|;':",./<>?`~]/.test(newPassword)) {
                errorMessage.textContent = 'A jelszónak tartalmaznia kell legalább egy speciális karaktert!';
                errorMessage.style.display = 'block';
                return;
            }

            if (newPassword !== confirmPassword) {
                errorMessage.textContent = 'A jelszavak nem egyeznek!';
                errorMessage.style.display = 'block';
                return;
            }

            // Gomb letiltása
            resetBtn.disabled = true;
            resetBtn.innerHTML = 'Mentés...';

            try {
                const response = await fetch(`${API_BASE_URL}/password/ResetUserPassword`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        token: token,
                        new_password: newPassword
                    })
                });

                const result = await response.json();

                if (response.ok && result.status === 'success') {
                    successMessage.textContent = 'Jelszó sikeresen megváltoztatva! Átirányítás...';
                    successMessage.style.display = 'block';

                    // Átirányítás a login oldalra
                    setTimeout(() => {
                        window.location.href = 'login.html';
                    }, 2000);
                } else {
                    errorMessage.textContent = result.message || 'Hiba történt a jelszó visszaállítása során.';
                    errorMessage.style.display = 'block';
                    resetBtn.disabled = false;
                    resetBtn.innerHTML = originalText;
                }
            } catch (error) {
                console.error('Jelszó visszaállítási hiba:', error);
                errorMessage.textContent = 'Hálózati hiba történt.';
                errorMessage.style.display = 'block';
                resetBtn.disabled = false;
                resetBtn.innerHTML = originalText;
            }
        }