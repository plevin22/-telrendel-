document.getElementById('sidebarToggle').addEventListener('click', () => document.getElementById('sidebar').classList.toggle('show'));

        // JAVÍTOTT API URL - a backend-hez igazítva
        const API_BASE = 'http://localhost:8080/vizsgaremek1/webresources';

        let payments = [], orders = [], users = [], currentFilter = 'all';

        async function loadData() {
            try {
                // JAVÍTOTT VÉGPONTOK
                const [paymentsRes, ordersRes, usersRes] = await Promise.all([
                    fetch(`${API_BASE}/payments/GetAllPayments`),
                    fetch(`${API_BASE}/orders/GetAllOrders`),
                    fetch(`${API_BASE}/users/GetAllUsers`)
                ]);
                if (paymentsRes.ok) payments = await paymentsRes.json();
                if (ordersRes.ok) orders = await ordersRes.json();
                if (usersRes.ok) users = await usersRes.json();
                calculateStats();
                renderPayments();
            } catch (e) {
                console.error('Hiba az adatok betöltésekor:', e);
            }
        }

        function calculateStats() {
            const today = new Date().toISOString().split('T')[0];
            let totalRevenue = 0, todayRevenue = 0, successfulPayments = 0, pendingPayments = 0;
            payments.forEach(p => {
                if (p.status === 'paid') {
                    totalRevenue += parseFloat(p.amount) || 0;
                    successfulPayments++;
                    if ((p.created_at || '').split('T')[0] === today) {
                        todayRevenue += parseFloat(p.amount) || 0;
                    }
                }
                else if (p.status === 'pending') {
                    pendingPayments++;
                }
            });
            document.getElementById('totalRevenue').textContent = formatPrice(totalRevenue);
            document.getElementById('todayRevenue').textContent = formatPrice(todayRevenue);
            document.getElementById('successfulPayments').textContent = successfulPayments;
            document.getElementById('pendingPayments').textContent = pendingPayments;
        }

        function renderPayments() {
            const list = document.getElementById('paymentsList');
            let filtered = currentFilter === 'all' ? payments : payments.filter(p => p.status === currentFilter);
            if (!filtered.length) {
                list.innerHTML = '<div class="empty-state"><div class="empty-state-icon">💳</div><p>Nincsenek fizetések.</p></div>';
                return;
            }
            filtered.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
            list.innerHTML = filtered.map(p => {
                const order = orders.find(o => o.order_id === p.order_id);
                const user = order ? users.find(u => u.user_id === order.user_id) : null;
                return `<div class="payment-item">
                    <div class="payment-icon">💳</div>
                    <div class="payment-info">
                        <div class="payment-customer">${user ? user.name : 'Ismeretlen'}</div>
                        <div class="payment-date">${formatDate(p.created_at)}</div>
                        <div class="payment-order">Rendelés: #${p.order_id}</div>
                    </div>
                    <div class="payment-amount">${formatPrice(p.amount)}</div>
                    <div class="payment-method ${p.method}">${getMethodName(p.method)}</div>
                    <div class="payment-status status-${p.status}">${getStatusName(p.status)}</div>
                </div>`;
            }).join('');
        }

        document.querySelectorAll('.filter-btn').forEach(btn => btn.addEventListener('click', () => {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentFilter = btn.dataset.filter;
            renderPayments();
        }));

        function getMethodName(m) {
            return {
                card: 'Bankkártya',
                cash: 'Készpénz',
                paypal: 'PayPal'
            }[m] || m || 'Ismeretlen';
        }

        function getStatusName(s) {
            return {
                pending: 'Függőben',
                paid: 'Sikeres',
                failed: 'Sikertelen'
            }[s] || s;
        }

        function formatPrice(p) {
            return new Intl.NumberFormat('hu-HU').format(Math.round(p)) + ' Ft';
        }

        function formatDate(d) {
            return d ? new Date(d).toLocaleString('hu-HU') : 'N/A';
        }

        document.addEventListener('DOMContentLoaded', loadData);