// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  $('#change_search').click(function(){ 
    var form = $('#new_search');
    form.toggle();
    $(this).text(form.is(":visible") ? '[hide]' : '[change]');
  });

  function initMaps() {
    $('.map_canvas').each(function() {
      var rinkLocation = new google.maps.LatLng($(this).attr('data-rink-lat'), $(this).attr('data-rink-lon'));
      var userLocation = new google.maps.LatLng($(this).attr('data-user-lat'), $(this).attr('data-user-lon'));
      var bounds = new google.maps.LatLngBounds();
      bounds.extend(rinkLocation);
      bounds.extend(userLocation);
      var mapOptions = {
        center: rinkLocation,
        zoom: 13,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      var map = new google.maps.Map(this, mapOptions);
      map.fitBounds(bounds);
      var rinkMarker = new google.maps.Marker({
        position: rinkLocation,
        map: map,
        title: $(this).attr('data-rink-name')
      });
    });
  }

  google.maps.event.addDomListener(window, 'load', initMaps);
});