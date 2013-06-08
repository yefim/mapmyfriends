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
  add_marker = (friend) ->
    map.addMarker
      lat: friend.lat
      lng: friend.lng
      title: friend.name
      infoWindow:
        content: """
                 <div class='info'>
                   <h1><a href='tel:#{friend.phone}'>#{friend.name}</a> <small>#{friend.phone}</small></h1>
                   <h3>#{friend.address}</h3>
                 </div>
                 """

  map = new GMaps(div: '#map-canvas', zoom: 12, lat: me.lat, lng: me.lng)
  map.addMarker me

  friends = localStorage.getObject('map-my-friends') or []
  friends.forEach add_marker

  document.getElementById('save').addEventListener 'click', ->
    [name, phone, address] = ['name', 'phone', 'address'].map (a) -> document.getElementById a
    GMaps.geocode
      address: address.value
      callback: (results, status) ->
        if status is 'OK'
          latlng = results[0].geometry.location
          friend =
            lat: latlng.lat()
            lng: latlng.lng()
            name: name.value
            phone: phone.value
            address: address.value

          map.setCenter(friend.lat, friend.lng)
          add_marker friend

          localStorage.pushObject('map-my-friends', friend)
