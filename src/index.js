import './styles.css';

import GMaps from 'gmaps';

const app = {
  map: null,
  render: function() {
    this.map = new GMaps({div: '#map-canvas', zoom: 12, lat: 37.75, lng: 237.55});
    console.log('rendering');
  }
};

app.render();
