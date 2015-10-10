# Custom coffee code goes here (client side, app-wide)
# Ideal for jQuery functions and other stuff.
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

$ ->
	$("#symptoms").keyup((ev) ->
		symptoms = $("#symptoms").val().split(/[\s,]+/);
		$("#filtered-symptoms").val(symptoms.join(','));
		console.dir symptoms;
	);
	$("#texti").val("");
  
