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
