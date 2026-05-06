import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      ghostClass: "opacity-30",
      

      // 👇 ドラッグ開始
      onStart: (event) => {
        event.item.classList.add(
          "opacity-70",
          "scale-105",
          "shadow-2xl",
          "cursor-grabbing"
        )
      },

      // 👇 ドラッグ終了（見た目 + 並び替え）
      onEnd: (event) => {
        // 見た目戻す
        event.item.classList.remove(
          "opacity-70",
          "scale-105",
          "shadow-2xl",
          "cursor-grabbing"
        )

        // 並び順送信
        const ids = Array.from(this.element.children).map(el =>
          el.id.replace("task_", "")
        )

        fetch("/tasks/reorder", {
          method: "PATCH",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document
              .querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ ids: ids })
        })
      }
    })
  }
}

