//= require fetch
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
    setTimeout(function(el) { el.style.opacity = 0.9; }, i*1000, el);
  }
}

fadeInElements();


/// MAP

var map = L.map("map").setView([20, 40], 2);

detectLocation(map);
fetchWebstores(map);
L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png").addTo(map);
setFooter(map);

// functions below:

function setFooter(map) {
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
}

function detectLocation(map) {
  var request = new Request("https://freegeoip.net/json/", {
    method: "GET",
    mode: "cors"
  });

  fetch(request).then(checkStatus).then(parseJSON).then(function(json) {

    var ll = [json.latitude, json.longitude]; // user's approximate location

    L.circle(ll, 50*1E3).addTo(map);
    map.setView(ll, 8);

  }).catch(function(err) {
    console.error(err);
  });
}

function fetchWebstores(map) {
  var request = new Request("https://api.buckybox.com/v1/webstores", {
    method: "GET",
    mode: "cors"
  });

  fetch(request).then(checkStatus).then(parseJSON).then(function(json) {

    for (var i = 0; i < json.length; i++) {
      var webstore = json[i];
      var ll = webstore.ll;

      if (ll[0] && ll[1]) { // if we have valid coordinates
        var marker = L.marker(webstore.ll, {alt: webstore.name}).addTo(map);
        marker.bindPopup("<b><a href='" + webstore.webstore_url + "' target='_blank'>" + webstore.name + "</a></b> - " + webstore.postal_address);
      }
    }

  }).catch(function(err) {
    console.error(err);
  });
}

function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  } else {
    var error = new Error(response.statusText);
    error.response = response;
    throw error;
  }
}

function parseJSON(response) {
  return response.json();
}

