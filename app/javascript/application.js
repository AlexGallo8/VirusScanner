import "@hotwired/turbo-rails"
import "controllers"

// window.startClerk = async () => {
//     try {
//         if (!window.Clerk) {
//             console.error('Clerk non è stato caricato correttamente');
//             return;
//         }

//         await window.Clerk.load({
//             // Aggiungi qui le opzioni di configurazione se necessarie
//         });

//         const mountUserButton = () => {
//             const userButtonEl = document.getElementById('user-button');
//             if (userButtonEl && !userButtonEl.hasChildNodes()) {
//                 window.Clerk.mountUserButton(userButtonEl);
//             }
//         };

//         // Usa gli eventi Turbo invece di Turbolinks
//         document.addEventListener("turbo:load", mountUserButton);
//         document.addEventListener("turbo:render", mountUserButton);

//         // Montaggio iniziale
//         mountUserButton();

//         console.log('Clerk inizializzato con successo');
//     } catch (err) {
//         console.error('Errore durante l\'inizializzazione di Clerk:', err);
//     }
// };

document.addEventListener("turbo:load", () => {
    if (window.Clerk) {
        const userButtonEl = document.getElementById('user-button');
        if (userButtonEl && !userButtonEl.hasChildNodes()) {
            window.Clerk.mountUserButton(userButtonEl);
        }
    }
});

document.addEventListener("turbo:render", () => {
    if (window.Clerk) {
        const userButtonEl = document.getElementById('user-button');
        if (userButtonEl && !userButtonEl.hasChildNodes()) {
            window.Clerk.mountUserButton(userButtonEl);
        }
    }
});