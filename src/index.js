import './styles.css';

import {map, forEach, isArray} from 'lodash-es';

const db = {
  key: 'MAP_MY_FRIENDS',
  getFriends: function() {
    try {
      const friends = JSON.parse(localStorage.getItem(this.key));
      return isArray(friends) ? friends : [];
    } catch (_e) {
      return [];
    }
  },
  saveFriend: function(friend) {
    const curr = this.getFriends();
    curr.push(friend);
    localStorage.setItem(this.key, JSON.stringify(curr));
  }
};

const app = {
  geocoder: null,
  map: null,
  onSubmit: function() {
    document.getElementById('input').addEventListener('submit', (e) => {
      e.preventDefault();

      const [name, phone, address] = map(['name', 'phone', 'address'], (a) => document.getElementById(a));

      this.geocoder.geocode({address: address.value}, (results, status) => {
        if (status === 'OK') {
          const latlng = results[0].geometry.location
          const friend = {
            lat: latlng.lat(),
            lng: latlng.lng(),
            name: name.value,
            phone: phone.value,
            address: address.value
          };
          forEach([name, phone, address], (i) => i.value = '');
          this.map.setCenter(latlng);
          this.addMarker(friend);
          db.saveFriend(friend);
        }
      });
    });
  },
  addMarker: function(friend) {
    const position = new google.maps.LatLng(friend.lat, friend.lng);
    const marker = new google.maps.Marker({position});
    marker.setMap(this.map);
  },
  render: function() {
    this.geocoder = new google.maps.Geocoder();
    this.map = new google.maps.Map(document.getElementById('map-canvas'), {
      center: {lat: 37.75, lng: 237.55},
      zoom: 12
    });
    this.onSubmit();
    const friends = db.getFriends();
    forEach(friends, this.addMarker.bind(this));
  }
};

window.initMap = app.render.bind(app);
