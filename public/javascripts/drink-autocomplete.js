var autoCompleteInit = function () {

	//alert("initializing drink autocomplete" + $("#drinksearch")[0])

	$("#drinksearch").on("autocompleteresponse", function(evt,ui) {
	
		var drinkName = $("#drinksearch")[0].value
	
		ui.content.push({
			label: "Add new drink \"" + drinkName + "\"...", 
			value: drinkName,
			addDrink: drinkName
		});
	
	});

	$("#drinksearch").on("autocompleteselect", function(evt,ui) {
	
		if (ui.item.addDrink)
		{
			evt.preventDefault();
			evt.stopImmediatePropagation();

			// open the new drink web page
			window.open("/drinks/new?name=" + encodeURIComponent(ui.item.addDrink), "_self")
		}
	
	});

};

// initialize for desktop
$(autoCompleteInit);

// initialize for jQuery Mobile
$(document).bind('pageinit', autoCompleteInit);