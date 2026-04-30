// Részletek gombok
        document.querySelectorAll('.btn-details').forEach(btn => {
            btn.addEventListener('click', function() {
                const orderId = this.closest('.order-item').querySelector('.order-id').textContent;
                alert(`Rendelés ${orderId} részletei megnyitva`);
            });
        });

        // Sidebar toggle for mobile
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');

        sidebarToggle.addEventListener('click', () => {
            sidebar.classList.toggle('show');
        });

        // Close sidebar when clicking outside on mobile
        document.addEventListener('click', (e) => {
            if (window.innerWidth <= 991) {
                if (!sidebar.contains(e.target) && !sidebarToggle.contains(e.target)) {
                    sidebar.classList.remove('show');
                }
            }
        });