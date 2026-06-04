import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  connect() {


    this.sortable = Sortable.create(this.element, {
      animation: 150,

      

      // 👇 プレースホルダー
      ghostClass: "drag-ghost",

      // 👇 掴んでる要素
      chosenClass: "drag-chosen",

      fallbackClass: "drag-fallback",


      // 👇 ドラッグ開始
      onStart: (event) => {
        console.log("START")
        
        console.log(event.clone)

        this.element.classList.add("sorting")

        console.log("FORCE", true)
        
        event.item.classList.add(
          "scale-105",
          "shadow-2xl",
          "cursor-grabbing"
        )
      },
      

      // 👇 ドラッグ終了
      onEnd: (event) => {
        // 見た目戻す
        this.element.classList.remove("sorting")

        event.item.classList.remove(
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
