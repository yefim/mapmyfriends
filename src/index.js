import './styles.css';

// libraries
import map from 'lodash-es/map';
import forEach from 'lodash-es/forEach'

// mapmyfriends
import {getFriends, saveFriend, deleteFriends} from './db';
import infoWindowTemplate from './info-window.ejs';

const app = {
  geocoder: null,
  map: null,
  markers: [],
  onSubmit: function() {
    const [name, phone, address] = map(['name', 'phone', 'address'], (a) => document.getElementById(a));

    document.getElementById('input').addEventListener('submit', (e) => {
      e.preventDefault();

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
          saveFriend(friend);
        }
      });
    });
  },
  onClear: function() {
    document.getElementById('clear').addEventListener('click', () => {
      const sure = confirm('Are you sure you want to clear all your friends?');

      if (sure) {
        forEach(this.markers, (marker) => {
          marker.setMap(null);
          marker = null;
        });
        this.markers = [];
        deleteFriends();
      }
    });
  },
  addMarker: function(friend) {
    const infoWindow = new google.maps.InfoWindow({
      content: infoWindowTemplate(friend)
    });
    const position = new google.maps.LatLng(friend.lat, friend.lng);
    const marker = new google.maps.Marker({title: friend.name, position});

    marker.addListener('click', function() {
      infoWindow.open(this.map, marker);
    });

    marker.setMap(this.map);

    this.markers.push(marker);
  },
  render: function() {
    this.geocoder = new google.maps.Geocoder();
    this.map = new google.maps.Map(document.getElementById('map-canvas'), {
      center: {lat: 37.75, lng: 237.55},
      zoom: 12
    });
    this.onSubmit();
    this.onClear();
    const friends = getFriends();
    forEach(friends, this.addMarker.bind(this));
  }
};

window.initMap = app.render.bind(app);
