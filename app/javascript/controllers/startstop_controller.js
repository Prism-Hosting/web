import { Controller } from "@hotwired/stimulus"

const loadingContainer = `
<div class="spinner-border spinner-border-sm" role="status">
  <span class="sr-only">Loading...</span>
</div>
`

/**
 * This will only trigger the POST request to /servers/:id/<start-or-stop> and render a loading indicator in the button
 * The updated button will be sent through the websocket connection.
 */
export default class extends Controller {
  click(e) {
    e.preventDefault()
    e.currentTarget.classList.add("disabled")
    e.currentTarget.innerHTML = loadingContainer
    fetch(e.currentTarget.href, { method: 'POST', headers: { 'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content } })
  }
}
