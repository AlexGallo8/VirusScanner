pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript", under: "application"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "application", to: "application.js", preload: true
pin "clerk_events", to: "clerk_events.js", preload: true

pin "@fontsource/inter", to: "https://ga.jspm.io/npm:@fontsource/inter@5.0.8/index.css"