 document.getElementById('sidebarToggle').addEventListener('click', () => document.getElementById('sidebar').classList.toggle('show'));

        // JAVÍTOTT API URL - a backend-hez igazítva
        const API_BASE = 'http://localhost:8080/vizsgaremek1/webresources';

        async function loadStatistics() {
            try {
                // JAVÍTOTT VÉGPONT: /orders/GetAllOrders
                const ordersRes = await fetch(`${API_BASE}/orders/GetAllOrders`);
                if (ordersRes.ok) {
                    const orders = await ordersRes.json();
                    const today = new Date().toISOString().split('T')[0];
                    let todayOrders = 0, dailyRevenue = 0, totalRevenue = 0;
                    orders.forEach(o => {
                        totalRevenue += parseFloat(o.total_price) || 0;
                        if ((o.created_at || '').split('T')[0] === today) {
                            todayOrders++;
                            dailyRevenue += parseFloat(o.total_price) || 0;
                        }
                    });
                    document.getElementById('todayOrders').textContent = todayOrders;
                    document.getElementById('dailyRevenue').textContent = formatPrice(dailyRevenue);
                    document.getElementById('totalRevenue').textContent = formatPrice(totalRevenue);
                }

                // JAVÍTOTT VÉGPONT: /users/GetAllUsers
                const usersRes = await fetch(`${API_BASE}/users/GetAllUsers`);
                if (usersRes.ok) {
                    document.getElementById('totalUsers').textContent = (await usersRes.json()).length;
                }
            } catch (e) {
                console.error('Hiba az adatok betöltésekor:', e);
            }
        }

        function formatPrice(p) {
            return new Intl.NumberFormat('hu-HU').format(Math.round(p)) + ' Ft';
        }

        document.addEventListener('DOMContentLoaded', loadStatistics);