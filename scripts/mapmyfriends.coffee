Storage::setObject = (key, val) ->
  @setItem(key, JSON.stringify val)

Storage::getObject = (key) ->
  val = @getItem key
  return val && JSON.parse(val)

Storage::pushObject = (key, val) ->
  a = @getObject(key) or []
  a.push val
  @setObject key, a


navigator.geolocation.getCurrentPosition (position) ->
  me = {lat: position.coords.latitude, lng: position.coords.longitude}
  add_marker = (person) ->
    map.addMarker
      lat: person.lat
      lng: person.lng
      click: ->
        map.drawRoute
          origin: [me.lat, me.lng]
          destination: [person.lat, person.lng]
          travelMode: 'driving'
          strokeColor: '#131540'
          strokeOpacity: 0.6
          strokeWeight: 6

  map = new GMaps(div: '#map-canvas', lat: me.lat, lng: me.lng)
  map.addMarker({lat: me.lat, lng: me.lng})

  people = localStorage.getObject('map-my-friends') or []
  for person in people
    add_marker {lat: person.lat, lng: person.lng}

  document.getElementById('save').addEventListener 'click', ->
    name_input = document.getElementById('name')
    phone_input = document.getElementById('phone')
    address_input = document.getElementById('address')
    GMaps.geocode
      address: address_input.value
      callback: (results, status) ->
        if status is 'OK'
          latlng = results[0].geometry.location
          [lat, lng] = [latlng.lat(), latlng.lng()]

          map.setCenter(lat, lng)
          add_marker {lat, lng}

          localStorage.pushObject('map-my-friends', {lat, lng})
