import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // ふわっと表示
    this.element.style.opacity = "0"
    this.element.style.transform = "translateY(-10px)"

    setTimeout(() => {
      this.element.style.transition = "all 0.3s ease"
      this.element.style.opacity = "1"
      this.element.style.transform = "translateY(0)"
    }, 50)

    // 消える
    setTimeout(() => {
      this.element.style.opacity = "0"
      this.element.style.transform = "translateY(-10px)"
    }, 1000)

    // 削除
    setTimeout(() => {
      this.element.remove()
    }, 1300)
  }
}