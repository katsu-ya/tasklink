// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

console.log("JS読み込まれた");

document.addEventListener("turbo:load", () => {
  const flash = document.querySelector(".flash-message");

  if (flash) {
    setTimeout(() => {
      flash.style.transition = "opacity 0.5s";
      flash.style.opacity = "0";
    }, 3000);

    setTimeout(() => {
      flash.remove();
    }, 3500);
  }
});



import "@hotwired/turbo-rails"
import "controllers"

