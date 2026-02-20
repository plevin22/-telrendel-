/**
 * KLSZ Faloda - Kártya UI JavaScript
 * Csak a bankkártya vizuális megjelenítés és input formázás
 * A fizetési logika a payment.js-ben van!
 */

document.addEventListener('DOMContentLoaded', function () {

    // --- Kártya beviteli mezők és forgatás ---
    const card = document.getElementById("credit-card");
    const cardNumber = document.getElementById("card-number");
    const cardName = document.getElementById("card-name");
    const cardExpiry = document.getElementById("card-expiry");
    const cardCvc = document.getElementById("card-cvc");
    const flipCardBtn = document.getElementById("flip-card-btn");

    if (flipCardBtn && card) {
        flipCardBtn.addEventListener("click", () => {
            if (card.classList.contains("flip")) {
                card.classList.remove("flip");
                flipCardBtn.innerHTML = '🔄 Kártya megfordítása (CVC kód)';
            } else {
                card.classList.add("flip");
                flipCardBtn.innerHTML = '🔄 Vissza az előlapra';
                setTimeout(() => { if (cardCvc) cardCvc.focus(); }, 400);
            }
        });
    }

    // Kártyaszám formázás (4-es csoportok)
    if (cardNumber) {
        cardNumber.addEventListener("input", (e) => {
            let value = e.target.value.replace(/\D/g, "").slice(0, 16);
            e.target.value = value.replace(/(.{4})/g, "$1 ").trim();
        });
    }

    // Lejárati dátum formázás (MM/YY)
    if (cardExpiry) {
        cardExpiry.addEventListener("input", (e) => {
            let value = e.target.value.replace(/\D/g, "").slice(0, 4);
            if (value.length > 2) value = value.slice(0, 2) + "/" + value.slice(2);
            e.target.value = value;
        });
    }

    // Név nagybetűs
    if (cardName) {
        cardName.addEventListener("input", (e) => {
            e.target.value = e.target.value.toUpperCase();
        });
    }

    // CVC csak szám, max 3 karakter
    if (cardCvc) {
        cardCvc.addEventListener("input", (e) => {
            e.target.value = e.target.value.replace(/\D/g, "").slice(0, 3);
        });

        // CVC fókuszra kártya megfordítása
        cardCvc.addEventListener("focus", () => {
            if (card) {
                card.classList.add("flip");
                if (flipCardBtn) flipCardBtn.innerHTML = '🔄 Vissza az előlapra';
            }
        });
    }

    // Előlapi mezők fókuszra kártya visszafordítása
    [cardNumber, cardName, cardExpiry].forEach(input => {
        if (input) {
            input.addEventListener("focus", () => {
                if (card) {
                    card.classList.remove("flip");
                    if (flipCardBtn) flipCardBtn.innerHTML = '🔄 Kártya megfordítása (CVC kód)';
                }
            });
        }
    });

});

console.log('Payment-card.js (UI only) betöltve');