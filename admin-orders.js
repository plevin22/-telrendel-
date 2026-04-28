document.getElementById('sidebarToggle').addEventListener('click', () => document.getElementById('sidebar').classList.toggle('show'));

        // JAVÍTOTT API URL - a backend-hez igazítva
        const API_BASE = 'http://localhost:8080/vizsgaremek1/webresources';

        let orders = [], users = [], currentFilter = 'all';

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
                    <div class="status-dropdown-wrapper" data-order-id="${o.order_id}">
                        <button type="button" class="status-badge-btn status-${o.status}">
                            ${getStatusName(o.status)}
                            <span class="dropdown-arrow">▼</span>
                        </button>
                        <div class="status-dropdown-menu">
                            <button type="button" class="status-dropdown-item ${o.status === 'pending' ? 'active' : ''}" data-status="pending">
                                <span class="status-dot pending"></span>Függőben
                            </button>
                            <button type="button" class="status-dropdown-item ${o.status === 'preparing' ? 'active' : ''}" data-status="preparing">
                                <span class="status-dot preparing"></span>Készül
                            </button>
                            <button type="button" class="status-dropdown-item ${o.status === 'delivering' ? 'active' : ''}" data-status="delivering">
                                <span class="status-dot delivering"></span>Kiszállítás alatt
                            </button>
                            <button type="button" class="status-dropdown-item ${o.status === 'completed' ? 'active' : ''}" data-status="completed">
                                <span class="status-dot completed"></span>Teljesítve
                            </button>
                            <button type="button" class="status-dropdown-item ${o.status === 'cancelled' ? 'active' : ''}" data-status="cancelled">
                                <span class="status-dot cancelled"></span>Törölve
                            </button>
                        </div>
                    </div>
                </div>`;
            }).join('');
        }

        document.querySelectorAll('.filter-btn').forEach(btn => btn.addEventListener('click', () => {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentFilter = btn.dataset.filter;
            renderOrders();
        }));

        // Dropdown eseménykezelők inicializálása
        function initDropdownEvents() {
            document.addEventListener('click', function(e) {
                const wrapper = e.target.closest('.status-dropdown-wrapper');
                const badgeBtn = e.target.closest('.status-badge-btn');
                const dropdownItem = e.target.closest('.status-dropdown-item');

                // Ha badge gombra kattintottak - toggle dropdown
                if (badgeBtn && wrapper) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    // Minden más dropdown bezárása
                    document.querySelectorAll('.status-dropdown-menu.show').forEach(menu => {
                        if (menu !== wrapper.querySelector('.status-dropdown-menu')) {
                            menu.classList.remove('show');
                            menu.closest('.status-dropdown-wrapper').querySelector('.status-badge-btn').classList.remove('open');
                        }
                    });
                    
                    // Aktuális dropdown toggle
                    const menu = wrapper.querySelector('.status-dropdown-menu');
                    menu.classList.toggle('show');
                    badgeBtn.classList.toggle('open');
                    return;
                }

                // Ha dropdown elemre kattintottak - státusz váltás
                if (dropdownItem && wrapper) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    const newStatus = dropdownItem.dataset.status;
                    const orderId = parseInt(wrapper.dataset.orderId);
                    
                    updateOrderStatus(orderId, newStatus, wrapper);
                    return;
                }

                // Kattintás máshol - dropdownok bezárása
                document.querySelectorAll('.status-dropdown-menu.show').forEach(menu => {
                    menu.classList.remove('show');
                    menu.closest('.status-dropdown-wrapper').querySelector('.status-badge-btn').classList.remove('open');
                });
            });

            // ESC gomb kezelése
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    document.querySelectorAll('.status-dropdown-menu.show').forEach(menu => {
                        menu.classList.remove('show');
                        menu.closest('.status-dropdown-wrapper').querySelector('.status-badge-btn').classList.remove('open');
                    });
                }
            });
        }

        // Státusz frissítése API híváson keresztül
        async function updateOrderStatus(orderId, newStatus, wrapper) {
            const menu = wrapper.querySelector('.status-dropdown-menu');
            const badgeBtn = wrapper.querySelector('.status-badge-btn');
            const order = orders.find(o => o.order_id === orderId);
            
            if (!order) return;

            // Dropdown bezárása
            menu.classList.remove('show');
            badgeBtn.classList.remove('open');
            
            // Loading állapot
            const originalContent = badgeBtn.innerHTML;
            badgeBtn.disabled = true;
            badgeBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span>';

            try {
                const res = await fetch(`${API_BASE}/orders/UpdateOrder/${orderId}`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        status: newStatus,
                        total_price: order.total_price
                    })
                });

                if (res.ok) {
                    // Sikeres frissítés - UI és orders tömb frissítése
                    order.status = newStatus;
                    badgeBtn.className = `status-badge-btn status-${newStatus}`;
                    badgeBtn.innerHTML = `${getStatusName(newStatus)}<span class="dropdown-arrow">▼</span>`;
                    badgeBtn.disabled = false;

                    // Active osztály frissítése
                    wrapper.querySelectorAll('.status-dropdown-item').forEach(item => {
                        item.classList.toggle('active', item.dataset.status === newStatus);
                    });
                } else {
                    const error = await res.json();
                    alert('Hiba: ' + (error.message || 'Ismeretlen hiba'));
                    badgeBtn.innerHTML = originalContent;
                    badgeBtn.disabled = false;
                }
            } catch (e) {
                console.error('Hiba a státusz frissítésekor:', e);
                alert('Hiba történt a művelet során!');
                badgeBtn.innerHTML = originalContent;
                badgeBtn.disabled = false;
            }
        }

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

        document.addEventListener('DOMContentLoaded', () => {
            loadData();
            initDropdownEvents();
        });