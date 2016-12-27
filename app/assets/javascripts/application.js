// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require autocomplete-rails
//= require jquery.infinitescroll
//= require drink-autocomplete

// callback is function(success?, lat, long, positionObj)
function getLocation(callback)
{
	if (navigator.geolocation)
	{
		navigator.geolocation.getCurrentPosition(function(position) {
				callback(true, position.coords.latitude, position.coords.longitude, position);
	  		}, 
			function() {
				callback(false);
			});
	}
	else if (google.gears)
	{
		var geo = google.gears.factory.create('beta.geolocation');
		geo.getCurrentPosition(function(position) {
				callback(true, position.coords.latitude, position.coords.longitude, position);
		  	}, 
			function() {
				callback(false);
			});
	}
	else
	{
		// geolocation not available
		callback(false);
	}
}


function set_time_zone_offset() {
    var current_time = new Date();
    document.cookie = 'time_zone=' + current_time.getTimezoneOffset();
}

$(set_time_zone_offset);