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
  [lat, lng] = [position.coords.latitude, position.coords.longitude]
  map = new GMaps(div: '#map-canvas', lat: lat, lng: lng)
  map.addMarker(lat: lat, lng: lng)

  people = localStorage.getObject('map-my-friends') or []
  for person in people
    map.addMarker(lat: person.lat, lng: person.lng)

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
          map.addMarker(lat: lat, lng: lng)

          localStorage.pushObject(lat: lat, lng: lng)
