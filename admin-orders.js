document.getElementById('sidebarToggle').addEventListener('click', () => document.getElementById('sidebar').classList.toggle('show'));

        // JAVÍTOTT API URL - a backend-hez igazítva
        const API_BASE = 'http://localhost:8080/vizsgaremek1/webresources';

        let orders = [], users = [], currentFilter = 'all', selectedOrderId = null;

        async function loadData() {
            try {
                // JAVÍTOTT VÉGPONTOK
                const [ordersRes, usersRes] = await Promise.all([
                    fetch(`${API_BASE}/orders/GetAllOrders`),
                    fetch(`${API_BASE}/users/GetAllUsers`)
                ]);
                if (ordersRes.ok) orders = await ordersRes.json();
                if (usersRes.ok) users = await usersRes.json();
                renderOrders();
            } catch (e) {
                console.error('Hiba az adatok betöltésekor:', e);
            }
        }

        function renderOrders() {
            const list = document.getElementById('ordersList');
            let filtered = currentFilter === 'all' ? orders : orders.filter(o => o.status === currentFilter);
            if (!filtered.length) {
                list.innerHTML = '<div class="empty-state"><div class="empty-state-icon">📦</div><p>Nincsenek rendelések.</p></div>';
                return;
            }
            filtered.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
            list.innerHTML = filtered.map(o => {
                const user = users.find(u => u.user_id === o.user_id);
                return `<div class="order-item">
                    <div class="order-info">
                        <div class="order-id">#${o.order_id}</div>
                        <div class="order-customer">${user ? user.name : 'Ismeretlen'}</div>
                        <div class="order-date">${formatDate(o.created_at)}</div>
                    </div>
                    <div class="order-amount">${formatPrice(o.total_price)}</div>
                    <div class="order-status status-${o.status}">${getStatusName(o.status)}</div>
                    <button class="btn-action btn-details" onclick="showStatusModal(${o.order_id}, '${o.status}')">Státusz</button>
                </div>`;
            }).join('');
        }

        document.querySelectorAll('.filter-btn').forEach(btn => btn.addEventListener('click', () => {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentFilter = btn.dataset.filter;
            renderOrders();
        }));

        function showStatusModal(id, status) {
            selectedOrderId = id;
            document.getElementById('statusSelect').value = status;
            new bootstrap.Modal(document.getElementById('statusModal')).show();
        }

        document.getElementById('confirmStatus').addEventListener('click', async () => {
            if (!selectedOrderId) return;
            const newStatus = document.getElementById('statusSelect').value;
            const order = orders.find(o => o.order_id === selectedOrderId);
            if (order) {
                try {
                    // JAVÍTOTT VÉGPONT: /orders/UpdateOrder/{id}
                    const res = await fetch(`${API_BASE}/orders/UpdateOrder/${selectedOrderId}`, {
                        method: 'PUT',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            status: newStatus,
                            total_price: order.total_price
                        })
                    });
                    if (res.ok) {
                        bootstrap.Modal.getInstance(document.getElementById('statusModal')).hide();
                        loadData();
                    } else {
                        const error = await res.json();
                        alert('Hiba: ' + (error.message || 'Ismeretlen hiba'));
                    }
                } catch (e) {
                    alert('Hiba történt a művelet során!');
                    console.error(e);
                }
            }
        });

        function getStatusName(s) {
            return {
                pending: 'Függőben',
                preparing: 'Készül',
                delivering: 'Kiszállítás',
                completed: 'Teljesítve',
                cancelled: 'Törölve'
            }[s] || s;
        }

        function formatPrice(p) {
            return new Intl.NumberFormat('hu-HU').format(Math.round(p)) + ' Ft';
        }

        function formatDate(d) {
            return d ? new Date(d).toLocaleString('hu-HU') : 'N/A';
        }

        document.addEventListener('DOMContentLoaded', loadData);