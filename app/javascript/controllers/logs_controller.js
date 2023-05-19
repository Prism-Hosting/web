import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container" ]

  connect() {
    this.containerTarget.scrollTo(0, this.containerTarget.scrollHeight);
  }
}
