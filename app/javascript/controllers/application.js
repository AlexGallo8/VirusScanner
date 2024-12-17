// import { Application } from "@hotwired/stimulus"

// const application = Application.start()
// export { application }

import { Application } from "@hotwired/stimulus"
import { enterFadeOut, leaveFadeOut } from 'el-transition'

const application = Application.start()

// Configures the application to handle Turbo events
application.handleEvent = (eventName, handler) => {
  document.addEventListener(eventName, handler)
  document.addEventListener(`turbo:${eventName}`, handler)
}

// Optional: Add more global configuration
application.debug = false

window.Stimulus = application

export { application }