// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

console.log("JS読み込まれた");

const observer = new MutationObserver(() => {
  const flashes = document.querySelectorAll(".flash-message")

  flashes.forEach((flash) => {
    // すでに処理済み防止
    if (flash.dataset.processed) return
    flash.dataset.processed = "true"

    setTimeout(() => {
      flash.style.transition = "all 0.3s ease"
      flash.style.opacity = "0"
      flash.style.transform = "translateY(-10px)"
    }, 1000)

    setTimeout(() => {
      flash.remove()
    }, 1300)
  })
})

// 画面の変化を監視
observer.observe(document.body, { childList: true, subtree: true })


document.addEventListener("turbo:load", () => {

  function setupToggle(fieldId, toggleId) {
    const field = document.getElementById(fieldId);
    const toggle = document.getElementById(toggleId);

    if (!field || !toggle) return;

    const eyeOpen = toggle.querySelector("#eye_open");
    const eyeClosed = toggle.querySelector("#eye_closed");

    toggle.addEventListener("click", () => {
      if (field.type === "password") {
        field.type = "text";
        eyeOpen.classList.add("hidden");
        eyeClosed.classList.remove("hidden");
      } else {
        field.type = "password";
        eyeOpen.classList.remove("hidden");
        eyeClosed.classList.add("hidden");
      }
    });
  }

  setupToggle("password_field", "toggle_password");
  setupToggle("password_confirmation_field", "toggle_password_confirmation");

});


document.addEventListener("turbo:frame-load", (e) => {
  if (e.target.id === "modal") {
    const modal = document.getElementById("modal-wrapper")
    modal.classList.remove("hidden")
    modal.classList.add("flex")
  }
})

function closeModal() {
  const modal = document.getElementById("modal-wrapper")
  modal.classList.add("hidden")
  modal.classList.remove("flex")

  document.getElementById("modal").innerHTML = ""
}

window.closeModal = closeModal


document.addEventListener("click", (e) => {
  const wrapper = document.getElementById("modal-wrapper")

  if (e.target === wrapper) {
    closeModal()
  }
})


document.addEventListener("turbo:submit-end", (e) => {
  if (e.detail.success) {
    closeModal()
  }
})


import "@hotwired/turbo-rails"
import "controllers"











