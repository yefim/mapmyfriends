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
      infoWindow:
        content: """
                 <div>
                   <h1>#{person.name}</h1>
                   <h2>#{person.phone}</h2>
                 </div>
                 """

  map = new GMaps(div: '#map-canvas', lat: me.lat, lng: me.lng)
  map.addMarker me

  people = localStorage.getObject('map-my-friends') or []
  people.forEach add_marker

  document.getElementById('save').addEventListener 'click', ->
    [name, phone, address] = ['name', 'phone', 'address'].map (a) -> document.getElementById a
    GMaps.geocode
      address: address.value
      callback: (results, status) ->
        if status is 'OK'
          latlng = results[0].geometry.location
          person = {lat: latlng.lat(), lng: latlng.lng(), name: name.value, phone: phone.value}

          map.setCenter(person.lat, person.lng)
          add_marker person

          localStorage.pushObject('map-my-friends', person)
