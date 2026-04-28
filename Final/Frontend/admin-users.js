document.getElementById('sidebarToggle').addEventListener('click', () => document.getElementById('sidebar').classList.toggle('show'));

        // JAVÍTOTT API URL - a backend-hez igazítva
        const API_BASE = 'http://localhost:8080/vizsgaremek1/webresources';

        let users = [], currentFilter = 'all', searchQuery = '', deleteUserId = null, editUserId = null;

        async function loadUsers() {
            try {
                // JAVÍTOTT VÉGPONT: /users/GetAllUsers
                const res = await fetch(`${API_BASE}/users/GetAllUsers`);
                if (res.ok) {
                    users = await res.json();
                    renderUsers();
                }
            } catch (e) {
                console.error('Hiba az adatok betöltésekor:', e);
            }
        }

        function renderUsers() {
            const list = document.getElementById('usersList');
            let filtered = users;

            // Hierarchia szűrés: csak az alacsonyabb szintű usereket látja
            // Owner (2): lát admin (1) + customer (0)
            // Admin (1): lát csak customer (0)
            const myLevel = getCurrentRoleLevel();
            filtered = filtered.filter(u => {
                const targetLevel = ROLE_HIERARCHY[u.role] || 0;
                return targetLevel < myLevel;
            });

            // Szűrés szerepkör alapján
            if (currentFilter !== 'all') {
                filtered = filtered.filter(u => u.role === currentFilter);
            }

            // Keresés
            if (searchQuery) {
                const q = searchQuery.toLowerCase();
                filtered = filtered.filter(u =>
                    (u.name && u.name.toLowerCase().includes(q)) ||
                    (u.email && u.email.toLowerCase().includes(q))
                );
            }

            if (!filtered.length) {
                list.innerHTML = '<div class="empty-state"><div class="empty-state-icon">👥</div><p>Nincsenek felhasználók.</p></div>';
                return;
            }

            list.innerHTML = filtered.map(u => {
                return `<div class="user-item">
                    <div class="user-avatar">👤</div>
                    <div class="user-info">
                        <div class="user-name">${escapeHtml(u.name || '')}</div>
                        <div class="user-email">${escapeHtml(u.email || '')}</div>
                        <div class="user-phone">${escapeHtml(u.phone || '')}</div>
                    </div>
                    <div class="user-role ${u.role}">${getRoleName(u.role)}</div>
                    <div class="user-date">${formatDate(u.created_at)}</div>
                    <div class="user-actions">
                        <button class="btn-action btn-edit" onclick="showEditModal(${u.user_id})">Szerkesztés</button>
                        <button class="btn-action btn-delete" onclick="showDeleteModal(${u.user_id}, '${escapeHtml(u.name || '')}')">Törlés</button>
                    </div>
                </div>`;
            }).join('');
        }

        document.querySelectorAll('.filter-btn').forEach(btn => btn.addEventListener('click', () => {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentFilter = btn.dataset.filter;
            renderUsers();
        }));

        document.getElementById('searchInput').addEventListener('input', e => {
            searchQuery = e.target.value;
            renderUsers();
        });

        function showDeleteModal(id, name) {
            const user = users.find(u => u.user_id === id);
            if (user && !canManageUser(user.role)) {
                alert('Nincs jogosultságod ennek a felhasználónak a törléséhez!');
                return;
            }
            deleteUserId = id;
            document.getElementById('deleteUserName').textContent = name;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function showEditModal(id) {
            const user = users.find(u => u.user_id === id);
            if (!user) return;

            // Ellenőrzés: jogosult-e kezelni ezt a usert
            if (!canManageUser(user.role)) {
                alert('Nincs jogosultságod ennek a felhasználónak a szerkesztéséhez!');
                return;
            }

            editUserId = id;
            document.getElementById('editUserId').value = id;
            document.getElementById('editName').value = user.name || '';
            document.getElementById('editUsername').value = user.username || '';
            document.getElementById('editEmail').value = user.email || '';
            document.getElementById('editPhone').value = user.phone || '';

            // Role dropdown szűrése: csak alacsonyabb szintű role-okat engedélyez
            const roleSelect = document.getElementById('editRole');
            const myLevel = getCurrentRoleLevel();
            Array.from(roleSelect.options).forEach(opt => {
                const optLevel = ROLE_HIERARCHY[opt.value] || 0;
                // Csak alacsonyabb szintű role-ok választhatók
                opt.disabled = optLevel >= myLevel;
                opt.style.display = optLevel >= myLevel ? 'none' : '';
            });
            roleSelect.value = user.role || 'customer';

            new bootstrap.Modal(document.getElementById('editModal')).show();
        }

        document.getElementById('confirmDelete').addEventListener('click', async () => {
            if (!deleteUserId) return;
            try {
                // JAVÍTOTT VÉGPONT: /users/DeleteUser/{id}
                const res = await fetch(`${API_BASE}/users/DeleteUser/${deleteUserId}`, { method: 'DELETE' });
                if (res.ok) {
                    bootstrap.Modal.getInstance(document.getElementById('deleteModal')).hide();
                    loadUsers();
                } else {
                    const error = await res.json();
                    alert('Hiba: ' + (error.message || 'Ismeretlen hiba'));
                }
            } catch (e) {
                alert('Hiba történt a törlés során!');
                console.error(e);
            }
        });

        document.getElementById('confirmEdit').addEventListener('click', async () => {
            if (!editUserId) return;

            const updateData = {
                name: document.getElementById('editName').value,
                username: document.getElementById('editUsername').value,
                email: document.getElementById('editEmail').value,
                phone: document.getElementById('editPhone').value,
                role: document.getElementById('editRole').value
            };

            try {
                // JAVÍTOTT VÉGPONT: /users/UpdateUser/{id}
                const res = await fetch(`${API_BASE}/users/UpdateUser/${editUserId}`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(updateData)
                });
                if (res.ok) {
                    bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
                    loadUsers();
                } else {
                    const error = await res.json();
                    alert('Hiba: ' + (error.message || 'Ismeretlen hiba'));
                }
            } catch (e) {
                alert('Hiba történt a mentés során!');
                console.error(e);
            }
        });

        function getRoleName(r) {
            return {
                customer: 'Vásárló',
                admin: 'Admin',
                restaurant_owner: 'Tulajdonos'
            }[r] || 'Vásárló';
        }

        function formatDate(d) {
            return d ? new Date(d).toLocaleDateString('hu-HU') : 'N/A';
        }

        function escapeHtml(t) {
            const d = document.createElement('div');
            d.textContent = t;
            return d.innerHTML;
        }

        document.addEventListener('DOMContentLoaded', function() {
            loadUsers();

            // Szűrő gombok elrejtése a hierarchia alapján
            // Admin (1): csak customer-t lát → elrejtjük az "Adminok" és "Tulajdonosok" füleket
            // Owner (2): admin + customer-t lát → elrejtjük a "Tulajdonosok" fület
            const myLevel = getCurrentRoleLevel();
            document.querySelectorAll('.filter-btn').forEach(btn => {
                const filterRole = btn.dataset.filter;
                if (filterRole === 'all') return; // "Összes" mindig látszik
                const filterLevel = ROLE_HIERARCHY[filterRole] || 0;
                if (filterLevel >= myLevel) {
                    btn.style.display = 'none';
                }
            });
        });