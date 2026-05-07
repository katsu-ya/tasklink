import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.classList.remove("hidden")

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
    this.element.classList.add("hidden")
  }
}

