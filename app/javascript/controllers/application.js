import { Application } from "@hotwired/stimulus"
import Clipboard from 'stimulus-clipboard'

const application = Application.start()
application.register('clipboard', Clipboard)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
