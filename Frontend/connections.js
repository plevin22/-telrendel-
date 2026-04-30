// Mai nap kiemelése a nyitvatartásban
        document.addEventListener('DOMContentLoaded', function() {
            const days = ['Vasárnap', 'Hétfő', 'Kedd', 'Szerda', 'Csütörtök', 'Péntek', 'Szombat'];
            const today = days[new Date().getDay()];
            
            const hoursRows = document.querySelectorAll('.hours-row');
            hoursRows.forEach(row => {
                const daySpan = row.querySelector('.hours-day');
                if (daySpan && daySpan.textContent === today) {
                    row.classList.add('today');
                }
            });
        });