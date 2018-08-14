import './styles.css';

import GMaps from 'gmaps';
import {map, forEach} from 'lodash-es';

const db = {
  getFriends: function() {
    return [];
  },
  saveFriend: function(friend) {
  }
};

const app = {
  map: null,
  onSubmit: function() {
    document.getElementById('input').addEventListener('submit', (e) => {
      e.preventDefault();
      const [name, phone, address] = map(['name', 'phone', 'address'], (a) => document.getElementById(a));
      GMaps.geocode({
        address: address.value,
        callback: (results, status) => {
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
            // map.setCenter(friend.lat, friend.lng)
            this.addMarker(friend);
            db.saveFriend(friend);
          }
      }
      });
    });
  },
  addMarker: function(friend) {
    console.log(`Adding friend ${JSON.stringify(friend)}...`);
  },
  render: function() {
    this.map = new GMaps({div: '#map-canvas', zoom: 12, lat: 37.75, lng: 237.55});
    this.onSubmit();
    const friends = db.getFriends();
    forEach(friends, this.addMarker);
  }
};

app.render();
