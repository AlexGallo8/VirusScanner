import { Application } from "@hotwired/stimulus"
import { registerControllers } from "stimulus-loading"
import ModalController from "./modal_controller"
import NavbarController from "./navbar_controller"

const application = Application.start()
registerControllers(application)
application.register('modal', ModalController)
application.register('navbar', NavbarController)
