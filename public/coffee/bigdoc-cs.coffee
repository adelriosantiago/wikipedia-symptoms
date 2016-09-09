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
	
	###
	exampleDiseases = 
		cold : "I cough often and have runny, stuffy nose. My troat is sore and congested. I've been sneezing a lot recently and I feel fatigued even when doing usual tasks like going upstairs.",
		#pneumonia :  "I am 60 years old. My main symptom is fever and cough and green mucus sometimes tinged with a bit of blood. My heartbeat is faster than usual and feel more tired and weak than usual.", #No longer used as it its symptoms are too difficult to notice...
		diabetes : "I constanly feel thirsty, like if I couldn't quench my thirst. By this reason I'm going to the bathroom very often, I go pee like 12 or 15 times a day when I would usually go like 4 times as much. Also, waking up and going to pee in the middle of the night is becoming really usual and annoying for me. As an additional symptom my vision is slightly blurred too."
		GERD : "I have a burning sensation in my chest, I describe it like \"fire\" inside my. When eating, I find it more difficult to swallow the food, therefore I eat and immediately drink water, usually cold water because of the \"fire\" feeling... Also I cough a lot and noticed that now I have a bad breath issue."
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
			
			$("#json").html JSON.stringify msg, null, 4
			window.wordsMatch = msg.diseases
			
			console.log msg.diseases
			
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
			else
				$("#dataSwitch .label").html('Switch to JSON');
				#Enable Word Cloud
				$("#json").hide();
				$("#wordcloud").show();
			
		
	$ "input[type=radio], #font, #max"
		.change () -> generate();
		

