// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

console.log("JS読み込まれた");

document.addEventListener("turbo:load", () => {
  console.log("turbo:load発火");

  const flashes = document.querySelectorAll('.flash');

  if (flashes.length === 0) return;

  setTimeout(() => {
    flashes.forEach(el => {
      el.style.transition = "opacity 0.5s";
      el.style.opacity = "0";

      setTimeout(() => {
        el.remove();
      }, 500);
    });
  }, 3000);
});

import "@hotwired/turbo-rails"
import "controllers"

