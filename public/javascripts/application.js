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
