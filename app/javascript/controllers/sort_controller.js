import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("🔥 connected")

    this.sortable = new Sortable(this.element, {
      animation: 150,
      onEnd: () => {
        this.updateOrder()
      }
    })
  }

  updateOrder() {
    const ids = Array.from(this.element.children).map(el => el.dataset.id)

    fetch("/tasks/sort", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ ids: ids })
    })
  }
}

