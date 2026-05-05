import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  fadeOutAndSubmit(event) {
  event.preventDefault()

  // 👇 ここ追加
  if (!window.confirm("本当に削除しますか？")) return

  const element = this.element.closest("[id^='task_']")
  const url = event.currentTarget.getAttribute("href")

  element.style.transition = "all 0.5s ease"
  element.style.opacity = "0"
  element.style.transform = "translateY(40px) scale(0.95)"

  setTimeout(() => {
    fetch(url, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(res => res.text())
    .then(html => Turbo.renderStreamMessage(html))
  }, 500)
}
}





