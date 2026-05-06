import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // 少し遅らせて発火（描画後に効かせる）
    // highlight_controller.js
setTimeout(() => {
  this.element.classList.remove("opacity-0", "translate-y-6", "scale-95")
}, 50)

setTimeout(() => {
  this.element.classList.remove("scale-105")
}, 400)

setTimeout(() => {
  this.element.classList.remove("bg-yellow-100")
}, 1200)
  }
}







