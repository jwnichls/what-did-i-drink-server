$().ready(function() {
	getLocation(function(success, lat, lng, position) {
		if (success)
		{
			$(".lat_field").val(lat);
			$(".lng_field").val(lng);
			$(".loc_link").attr("href", function(idx, val) { 
			
				if (val.indexOf("?") > 0)
					return val + "&lat=" + lat + "&lng=" + lng;
				else
					return val + "?lat=" + lat + "&lng=" + lng;
			});
		}
		
		$(".loc_button").removeAttr("disabled");
	});
});
