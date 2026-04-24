// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

console.log("JS読み込まれた");

document.addEventListener("turbo:load", () => {
  const flash = document.querySelector(".flash-message");

  if (flash) {
    // 初期位置（少し上）
    flash.style.transform = "translateY(-10px)";
    flash.style.opacity = "0";

    // 表示
    setTimeout(() => {
      flash.style.transition = "all 0.3s ease";
      flash.style.transform = "translateY(0)";
      flash.style.opacity = "1";
    }, 50);

    // 3秒後に消す
    setTimeout(() => {
      flash.style.opacity = "0";
      flash.style.transform = "translateY(-10px)";
    }, 3000);

    // 削除
    setTimeout(() => {
      flash.remove();
    }, 3500);
  }
});

document.addEventListener("turbo:load", () => {

  function setupToggle(fieldId, toggleId) {
    const field = document.getElementById(fieldId);
    const toggle = document.getElementById(toggleId);

    if (!field || !toggle) {
      console.log("見つからない:", fieldId, toggleId);
      return;
    }

    toggle.addEventListener("click", () => {
      if (field.type === "password") {
        field.type = "text";
        toggle.textContent = "🙈";
      } else {
        field.type = "password";
        toggle.textContent = "👁";
      }
    });
  }

  setupToggle("password_field", "toggle_password");
  setupToggle("password_confirmation_field", "toggle_password_confirmation");

});


import "@hotwired/turbo-rails"
import "controllers"

