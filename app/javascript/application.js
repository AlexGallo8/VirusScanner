import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

window.Stimulus = application
// document.addEventListener("turbo:load", () => {
//     if (window.Clerk) {
//         const userButtonEl = document.getElementById('user-button');
//         if (userButtonEl && !userButtonEl.hasChildNodes()) {
//             window.Clerk.mountUserButton(userButtonEl);
//         }
//     }
// });

// document.addEventListener("turbo:render", () => {
//     if (window.Clerk) {
//         const userButtonEl = document.getElementById('user-button');
//         if (userButtonEl && !userButtonEl.hasChildNodes()) {
//             window.Clerk.mountUserButton(userButtonEl);
//         }
//     }
// });
