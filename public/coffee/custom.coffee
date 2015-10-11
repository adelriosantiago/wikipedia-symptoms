# Bigdoc big data symptom analysis by @adelriosantiago
# 
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

$ ->
	connectorStr = ['the', 'and', 'or']
	relevantStr = ['pain', 'coughing', 'sneezing']
	
	do filter_diseases = ->
		outString = $("#symptoms").val().replace(/[`~!@#$%^&*()_|+\=?;:'",.<>\{\}\[\]\\\/]/gi, ' ');
		symptoms = outString.split /[\s,]+/
		filtered = []
		
		for word in symptoms
			if word in connectorStr then filtered.push '<span class="connector">' + word + '</span>' 
			else if word in relevantStr then filtered.push '<span class="relevant">' + word + '</span>' 
			else filtered.push word
		
		$("#filtered-symptoms").html filtered.join ','
		console.dir symptoms
	
	$("#symptoms").keyup((ev) -> filter_diseases());
	
	
	$("#texti").val("")
  
