# Custom coffee code goes here (client side, app-wide)
# Ideal for jQuery functions and other stuff.
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

$ ->
	connector = ['the', 'and', 'or']
	relevant = ['pain', 'coughing', 'sneezing']
	
	$("#symptoms").keyup((ev) ->
		symptoms = $("#symptoms").val().split(/[\s,]+/)
		filtered = []
		
		for word in symptoms
			if word in connector then filtered.push '<span class="connector">' + word + '</span>' 
			else if word in relevant then filtered.push '<span class="relevant">' + word + '</span>' 
			else filtered.push word
		
		$("#filtered-symptoms").html(filtered.join(','))
		console.dir symptoms
	);
	$("#texti").val("")
  
