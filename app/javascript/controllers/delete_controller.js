import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "serverName", "input", "button" ]

  inputUpdated() {
    this.buttonTarget.disabled = this.serverNameTarget.textContent.toLowerCase() !== this.inputTarget.value.toLowerCase()
  }
}
