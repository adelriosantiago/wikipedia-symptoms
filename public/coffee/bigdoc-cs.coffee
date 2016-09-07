# Bigdoc big data symptom analysis by @adelriosantiago

window.thecloud = null;
window.drawfunc = null;
window.wordsMatch = null;

$ ->
	###
	#TODO: Implement word quantity by slider
	$('#cloudCount').slider {
		formatter : (value) ->
			return "abc: " + value
		}
	###
	
	connectorStr = ['the', 'and', 'or']
	relevantStr = ['pain', 'coughing', 'sneezing']
	jsonOnly = false
	
	filter_diseases = ->
		outString = $("#symptoms").val().replace(/[`~!@#$%^&*()_|+\=?;:'",.<>\{\}\[\]\\\/]/gi, ' ');
		symptoms = outString.split /[\s,]+/
		filtered = []
		
		callUrl = 'api/diagnose?symptoms=' + outString
		console.log callUrl
		$.get callUrl, (msg) ->
			console.log msg
			if jsonOnly
				$("#json").html JSON.stringify msg, null, 4
			else
				window.wordsMatch = msg.diseases
				generate()
		.error (err) ->
			console.log "Error"
		
		#Show the words in the relevance box
		for word in symptoms
			if word in connectorStr then filtered.push '<span class="connector">' + word + '</span>' 
			else if word in relevantStr then filtered.push '<span class="relevant">' + word + '</span>' 
			else filtered.push word
		
		$ "#filtered-symptoms"
			.html filtered.join ','
	
	$ "#symptoms" 
		.keyup((ev) -> filter_diseases())
		
	$ "#dataSwitch" 
		.on 'click', (ev) -> 
			jsonOnly = !jsonOnly
			
			
			if jsonOnly
				$("#dataSwitch .label").html("Switch to Word Cloud");
				#Enable JSON
				$("#json").show();
				$("#wordcloud").hide();
				refreshRate = 100
			else
				$("#dataSwitch .label").html('Switch to JSON');
				#Enable Word Cloud
				$("#json").hide();
				$("#wordcloud").show();
				refreshRate = 500
			
		
	$ "input[type=radio], #font, #max"
		.change () -> generate();
		

