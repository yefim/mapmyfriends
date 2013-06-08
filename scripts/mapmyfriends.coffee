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
      title: person.name
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
  people.forEach add_marker

  document.getElementById('save').addEventListener 'click', ->
    name_input = document.getElementById('name')
    phone_input = document.getElementById('phone')
    address_input = document.getElementById('address')
    GMaps.geocode
      address: address_input.value
      callback: (results, status) ->
        if status is 'OK'
          latlng = results[0].geometry.location
          person =
            lat: latlng.lat()
            lng: latlng.lng()
            name: name_input.value
            phone: phone_input.value

          map.setCenter(person.lat, person.lng)
          add_marker person

          localStorage.pushObject('map-my-friends', person)
