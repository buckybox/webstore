//= require fetch
//= require leaflet

(function() {
  "use strict";

  /// LIGHTBOX

  // assume there is only one lightbox present at a time
  var lightbox = document.querySelectorAll(".lightbox")[0];

  if (document.cookie.indexOf("skip_lightbox=1") !== -1) {
    lightbox.remove();
  } else {
    lightbox.addEventListener("click", function(e) { this.remove(); });

    (function fadeInElements() {
      var elements = lightbox.querySelectorAll(".fade-in");
      for (var i = 0; i < elements.length; i++) {
        var el = elements[i];
        setTimeout(function(el) { el.style.opacity = 0.9; }, i*1000, el);
      }
    })();
  }


  /// MAP

  function MapData() {
    this.userLocation = null;
    this.stores = null;
  }

  var mapData = new MapData();

  addEventListener("userLocationAcquired", function(e) {
    mapData.userLocation = e.detail;
    tryToPan();
  });

  addEventListener("storesAcquired", function(e) {
    mapData.stores = e.detail;
    tryToPan();
  });

  var map = L.map("map").setView([20, 40], 2);

  detectLocation(map);
  fetchStores(map);
  setFooter(map);
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png").addTo(map);

  // functions below:

  function tryToPan() {
    if (!mapData.userLocation || !mapData.stores) return;

    var userLocation = mapData.userLocation,
        stores = mapData.stores,
        minDistance = Number.MAX_VALUE,
        closestStore = null;

    stores.forEach(function(store) {
      var storeLocation = L.latLng(store.ll),
          distance = storeLocation.distanceTo(userLocation);

      if (distance < minDistance) {
        minDistance = distance;
        closestStore = store;
      }
    });

    map.fitBounds([userLocation, closestStore.ll], { maxZoom: 8 });
  }

  function setFooter(map) {
    map.attributionControl.setPrefix('Map powered by <a href="http://www.openstreetmap.org/" target="_blank">OpenStreetMap</a> and <a href="http://leafletjs.com" target="_blank">Leaflet</a>');

    var FooterControl = L.Control.extend({
      options: { position: "bottomleft" },
      onAdd: function (map) {
        var container = L.DomUtil.create("div", "leaflet-control-attribution");

        container.innerHTML = 'Map of  stores powered by ' +
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

      var userLocation = L.latLng(json.latitude, json.longitude);
      L.circle(userLocation, 50*1E3, { clickable: false, stroke: false }).addTo(map);

      var event = new CustomEvent("userLocationAcquired", { 'detail': userLocation });
      dispatchEvent(event);

    }).catch(function(err) {
      console.error(err);
    });
  }

  function fetchStores(map) {
    var request = new Request("https://api.buckybox.com/v1/webstores", {
      method: "GET",
      mode: "cors"
    });

    fetch(request).then(checkStatus).then(parseJSON).then(function(json) {

      var event = new CustomEvent("storesAcquired", { 'detail': json });
      dispatchEvent(event);

      json.forEach(function(store) {
        var ll = store.ll;

        if (ll[0] && ll[1]) { // if we have valid coordinates
          var marker = L.marker(store.ll, {alt: store.name}).addTo(map);
          marker.bindPopup("<b><a href='" + store.webstore_url + "'>" + store.name + "</a></b> - " + store.postal_address);
        }
      });

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

})();
