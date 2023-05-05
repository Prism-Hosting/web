import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "command", "icon" ]

  async copy() {
    await navigator.clipboard.writeText(this.commandTarget.value)
    this.iconTarget.classList = "fa fa-check"
    setTimeout(() => {
      this.iconTarget.classList = "fa fa-copy"
    }, 2000)
  }
}
