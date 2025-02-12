import { Application } from "@hotwired/stimulus"
import { registerControllers } from "stimulus-loading"

const application = Application.start()
registerControllers(application);
