import { Application } from "@hotwired/stimulus"

import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.interceptLinkClick = (link) {
  return false
}

const application = Application.start()
export { application }