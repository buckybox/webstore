//= require leaflet

"use strict";


/// LIGHTBOX

// assume there is only one lightbox present at a time
var lightbox = document.querySelectorAll(".lightbox")[0];
lightbox.addEventListener("click", function(e) { this.remove(); });

function fadeInElements() {
  var elements = lightbox.querySelectorAll(".fade-in");
  for (var i = 0; i < elements.length; i++) {
    var el = elements[i];
    setTimeout(function(el) { el.style.opacity = 0.75; }, i*1000, el);
  }
}


/// MAP

var map = L.map('map').setView([20, 40], 2);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

if ("geolocation" in navigator) {
  navigator.geolocation.getCurrentPosition(function(position) {
    var lat = position.coords.latitude, lon = position.coords.longitude;
    var ll = [lat, lon];

    var marker = L.marker(ll).addTo(map);

    map.setView(ll, 10);

    fadeInElements();

    //console.log(window.navigator.language);
  }, function(error) {
    console.log("user refused geolocation");
    fadeInElements();
    // fall back to IP location?
  });
} else {
  console.warn("geolocation unavailable");
  fadeInElements();
  // fall back to IP location?
}

