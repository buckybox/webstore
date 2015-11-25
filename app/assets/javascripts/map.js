//= require leaflet

"use strict";


/// LIGHTBOX

// assume there is only one lightbox present at a time
var lightbox = document.querySelectorAll(".lightbox")[0];
lightbox.addEventListener("click", function(e) { this.remove(); });


/// MAP

var map = L.map('map').setView([20, 40], 2);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

if ("geolocation" in navigator) {
  navigator.geolocation.getCurrentPosition(function(position) {
    var lat = position.coords.latitude, lon = position.coords.longitude;
    var ll = [lat, lon];

    var marker = L.marker(ll).addTo(map);

    map.setView(ll, 10);

    //console.log(window.navigator.language);
  });
} else {
  /* geolocation IS NOT available */
}
