document.addEventListener('DOMContentLoaded', function() {
  var burgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  if (burgers.length > 0) {
    burgers.forEach(function(e) {
      e.addEventListener('click', function() {
        var target = document.getElementById(e.dataset.target);
        e.classList.toggle('is-active');
        target.classList.toggle('is-active');
      });
    });
  }

  var dropdowns = Array.prototype.slice.call(document.querySelectorAll('.navbar-dropdown'), 0);

  if (dropdowns.length > 0) {
    dropdowns.forEach(function(e) {
      e.addEventListener('click', function() {
        var target = document.getElementById(e.dataset.target);
        target.classList.toggle('is-active');
      });
    });
  }
});
