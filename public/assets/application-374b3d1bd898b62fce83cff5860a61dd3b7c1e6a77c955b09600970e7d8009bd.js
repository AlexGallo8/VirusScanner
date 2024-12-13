import "@hotwired/turbo-rails"
import "controllers"
import './clerk_events'

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

// const mountClerkButtons = () => {
//     if (!window.Clerk) return;

//     // Configurazione comune per entrambi i bottoni
//     const buttonConfig = {
//         afterSignOutUrl: '/',
//         userProfileUrl: '/profile'
//     };

//     // Desktop button
//     const desktopUserButtonEl = document.getElementById('user-button');
//     if (desktopUserButtonEl && !desktopUserButtonEl.hasChildNodes()) {
//         window.Clerk.mountUserButton(desktopUserButtonEl, buttonConfig);
//     }

//     // Mobile button
//     const mobileUserButtonEl = document.getElementById('mobile-user-button');
//     if (mobileUserButtonEl && !mobileUserButtonEl.hasChildNodes()) {
//         window.Clerk.mountUserButton(mobileUserButtonEl, buttonConfig);
//     }
// };

// // Inizializzazione di Clerk
// document.addEventListener('DOMContentLoaded', function() {
//     if (window.Clerk) {
//         window.Clerk.load()
//             .then(mountClerkButtons)
//             .catch(error => {
//                 console.error('Error loading Clerk:', error);
//             });
//     }
// });

// // Gestione della ri-mount con Turbo
// document.addEventListener("turbo:load", mountClerkButtons);
// document.addEventListener("turbo:render", mountClerkButtons);
