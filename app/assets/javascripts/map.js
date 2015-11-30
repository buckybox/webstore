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

var map = L.map("map").setView([20, 40], 2);

fetchWebstores(map);

L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png").addTo(map);

map.attributionControl.setPrefix('Map powered by <a href="http://www.openstreetmap.org/" target="_blank">OpenStreetMap</a> and <a href="http://leafletjs.com" target="_blank">Leaflet</a>');

var FooterControl = L.Control.extend({
  options: { position: "bottomleft" },
  onAdd: function (map) {
    var container = L.DomUtil.create("div", "leaflet-control-attribution");

    container.innerHTML = 'Map of web stores powered by ' +
      '<a target="_blank" href="http://www.buckybox.com">Bucky Box</a>, ' +
      'an ordering system for local food organisations';

    return container;
  }
});

map.addControl(new FooterControl());

if ("geolocation" in navigator) {
  navigator.geolocation.getCurrentPosition(function(position) {
    var lat = position.coords.latitude, lng = position.coords.longitude;
    var ll = [lat, lng];

    var marker = L.marker(ll).addTo(map);
    marker.bindPopup("Your approximate location");

    map.setView(ll, 10);

    fadeInElements();
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

function fetchWebstores(map) {
  var request = new Request("https://api.buckybox.com/v1/webstores", {
    method: "GET",
    mode: "cors"
  });

  fetch(request).then(function(response) {
    return response.json();
  }).then(function(json) {

    for (var i = 0; i < json.length; i++) {
      var webstore = json[i];
      var ll = webstore.ll;

      if (ll[0] && ll[1]) { // if we have valid coordinates
        var marker = L.marker(webstore.ll, {alt: webstore.name}).addTo(map);
        marker.bindPopup("<b><a href='" + webstore.webstore_url + "' target='_blank'>" + webstore.name + "</a></b><br>" + webstore.postal_address);
      }
    }

  }).catch(function(err) {
    console.error(err);
  });
}

