import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    this.element.addEventListener("celebrate", () => {
      this.celebrate()
    })
  }

  celebrate() {
    for (let i = 0; i < 12; i++) {
      const sparkle = document.createElement("div")

      sparkle.innerText = ["✨", "🎉", "⭐", "💫"][
        Math.floor(Math.random() * 4)
      ]

      sparkle.className = "confetti"

      sparkle.style.left = `${Math.random() * 100}%`
      sparkle.style.top = `${Math.random() * 100}%`

      this.element.appendChild(sparkle)

      setTimeout(() => {
        sparkle.remove()
      }, 1000)
    }
  }
}


