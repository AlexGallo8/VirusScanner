import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["userAuthLink", "mobileMenu", "mobileMenuButton"]

  connect() {
    console.log("Controller connected:", this.element)
    this.bindUserAuthLinks()
    this.bindMobileMenu()
  }

  bindUserAuthLinks() {
    // Safely bind click events to user auth links
    if (this.hasUserAuthLinkTargets) {
      this.userAuthLinkTargets.forEach(link => {
        link.addEventListener("click", (event) => {
          event.preventDefault()
          this.openModal(event)
        })
      })
    }
  }

  bindMobileMenu() {
    // Mobile menu toggle
    if (this.hasMobileMenuButtonTarget && this.hasMobileMenuTarget) {
      this.mobileMenuButtonTarget.addEventListener("click", () => {
        this.mobileMenuTarget.classList.toggle("hidden")
      })
    }
  }

  openModal(event) {
    // Find and trigger the modal
    const modal = document.querySelector('[data-controller="modal"]')
    if (modal) {
      const modalController = modal.controller('modal')
      if (modalController && typeof modalController.showModal === 'function') {
        modalController.showModal(event)
      }
    }
  }
}