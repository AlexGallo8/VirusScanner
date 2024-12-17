import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ["wrapper", "backdrop", "panel", "closeButton"]

  connect() {
    console.log("Controller connected:", this.element)
    // Attach click event to close button if it exists
    if (this.hasCloseButtonTarget) {
      this.closeButtonTarget.addEventListener("click", () => this.close())
    }

    // Attach global click event to handle outside clicks
    document.addEventListener("click", this.handleOutsideClick.bind(this))
  }

  disconnect() {
    // Clean up event listeners
    document.removeEventListener("click", this.handleOutsideClick.bind(this))
  }

  showModal(event) {
    event?.preventDefault()

    // Ensure all modal elements exist before manipulating
    if (this.hasWrapperTarget && this.hasBackdropTarget && this.hasPanelTarget) {
      this.wrapperTarget.classList.remove("hidden")
      this.backdropTarget.classList.remove("hidden")
      this.panelTarget.classList.remove("hidden")
    }
  }

  close(event) {
    event?.preventDefault()

    // Ensure all modal elements exist before hiding
    if (this.hasWrapperTarget && this.hasBackdropTarget && this.hasPanelTarget) {
      this.wrapperTarget.classList.add("hidden")
      this.backdropTarget.classList.add("hidden")
      this.panelTarget.classList.add("hidden")
    }
  }

  handleOutsideClick(event) {
    // Check if modal is open and click is outside modal panel
    if (
      !this.hasPanelTarget || 
      this.panelTarget.classList.contains("hidden")
    ) return

    const isOutsideModal = 
      this.panelTarget && 
      !this.panelTarget.contains(event.target) && 
      event.target !== this.panelTarget

    if (isOutsideModal) {
      this.close()
    }
  }
}