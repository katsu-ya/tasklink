import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.wrapper = document.getElementById("modal-wrapper")

    this.handleKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.handleKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  close() {
    this.element.innerHTML = ""

    this.wrapper.classList.add("hidden")
    this.wrapper.classList.remove("flex")
  }
}
