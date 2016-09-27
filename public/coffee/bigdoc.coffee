# Bigdoc big data symptom analysis by @adelriosantiago

$ ->
	fill = d3.scale.category20b()
	w = 800
	h = 600
	words = []
	max = undefined
	scale = 1
	complete = 0
	keyword = ''
	fontSize = undefined
	maxLength = 100
	fetcher = undefined
	statusText = d3.select('#status')
	layout = d3.layout.cloud().timeInterval(10).size([
		w
		h
	]).fontSize((t) ->
		fontSize +t.value
	).text((t) ->
		t.key
	).on('word', progress).on('end', draw)
	svg = d3.select('#wordcloud').append('svg').attr('width', w).attr('height', h)
	background = svg.append('g')
	vis = svg.append('g').attr('transform', 'translate(' + [
		w >> 1
		h >> 1
	] + ')')
	#vis = svg.append("g")
	#    .attr("width", '100%')
	#    .attr("height", '100%')
	
	generate = (wordsMatch) ->
		console.log "generate"
		
		#TODO: Sort descending the array wordsMatch here
		layout.font(d3.select('#font').property('value')).spiral d3.select('input[name=spiral]:checked').property('value')
		fontSize = d3.scale[d3.select('input[name=scale]:checked').property('value')]().range([
			10
			50
		])
		wordsMatch.length and fontSize.domain([
			+wordsMatch[wordsMatch.length - 1].value or 1
			+wordsMatch[0].value
		])
		complete = 0
		words = []
		layout.stop().words(wordsMatch.slice(0, max = Math.min(wordsMatch.length, +d3.select('#max').property('value')))).start()
		return
		
	#TODO: Change this last method to CS
	`function draw(t, e) {
		console.log("draw");
		scale = e ? Math.min(w / Math.abs(e[1].x - w / 2), w / Math.abs(e[0].x - w / 2), h / Math.abs(e[1].y - h / 2), h / Math.abs(e[0].y - h / 2)) / 2 : 1;
		words = t;
		var n = vis.selectAll("text").data(words, function(t) {
			return t.text.toLowerCase()
		});
		
		//Draw the new words
		n.transition().duration(1e3).attr("transform", function(t) {
			return "translate(" + [t.x, t.y] + ")rotate(" + t.rotate + ")"
		}).style("font-size", function(t) {
			return t.size + "px"
		}), n.enter().append("text").attr("text-anchor", "middle").attr("transform", function(t) {
			return "translate(" + [t.x, t.y] + ")rotate(" + t.rotate + ")"
		}).style("font-size", "1px").transition().duration(3e3).style("font-size", function(t) {
			return t.size + "px"
		}), n.style("font-family", function(t) {
			return t.font
		}).style("fill", function(t) {
			return fill(t.text.toLowerCase())
			//return "red"; //This would make all words red initially
		}).text(function(t) {
			return t.text
		});
		
		var a = background.append("g").attr("transform", vis.attr("transform")),
			r = a.node();
			
		n.exit().each(function() {
			r.appendChild(this)
		})
		
		a.transition().duration(3e3).style("opacity", 1e-6).remove(), //Clear the old words
		//a.transition().duration(5e3).style("font-size", "1px"); //Why is this not working!?
		
		//Slowly zoom to the results
		vis.transition().duration(3e3).attr("transform", "translate(" + [w >> 1, h >> 1] + ")scale(" + scale + ")")
			.each("end", _.once(function() {
				console.log("end");
				//TODO: Remove top coloring
				n.transition().duration(3e3).style("fill", function(t) {
					//return fill(t.text.toLowerCase()) //This would make all words randomly colorful
					if (t.size > 45) {
						return "rgb(" + t.size * 5 + ", 0, 0)";
					} else {
						return "rgb(" + (255 - (t.size * 5)) + ", " + (255 - (t.size * 5)) + ", 255)";
					}
				})
			}));
	}
	
	function progress() {
		bar.set(++complete / max);
	}`
	
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
		#pneumonia : "I am 60 years old. My main symptom is fever and cough and green mucus sometimes tinged with a bit of blood. My heartbeat is faster than usual and feel more tired and weak than usual.", #No longer used as it its symptoms are too difficult to notice...
		diabetes : "I constanly feel thirsty, like if I couldn't quench my thirst. By this reason I'm going to the bathroom very often, I go pee like 12 or 15 times a day when I would usually go like 4 times as much. Also, waking up and going to pee in the middle of the night is becoming really usual and annoying for me. As an additional symptom my vision is slightly blurred too."
		GERD : "I have a burning sensation in my chest, I describe it like \"fire\" inside my. When eating, I find it more difficult to swallow the food, therefore I eat and immediately drink water, usually cold water because of the \"fire\" feeling... Also I cough a lot and noticed that now I have a bad breath issue."
	###
	
	connectorStr = ['the', 'and', 'or']
	relevantStr = ['pain', 'coughing', 'sneezing']
	jsonOnly = false
	wordsMatch = {}
	
	filter_diseases = (limit) ->
		outString = $("#symptoms").val().replace(/[`~!@#$%^&*()_|+\=?;:'",.<>\{\}\[\]\\\/]/gi, ' ');
		symptoms = outString.split /[\s,]+/
		filtered = []
		
		callUrl = 'api/diagnose?symptoms=' + outString + '&limit=' + limit
		$.get callUrl, (msg) ->
			$("#json").html JSON.stringify msg, null, 4
			wordsMatch = msg.diseases
			generate(wordsMatch)
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
		.keyup((ev) -> filter_diseases +d3.select("#max").property("value"))
		
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
		.change () ->
			max = +d3.select("#max").property("value")
			filter_diseases max
			return
	
	bar = new (ProgressBar.Line)(progressBar,
		strokeWidth: 4
		color: '#CDCDFF'
		trailColor: '#F3F3F3'
		trailWidth: 1
		svgStyle:
			width: '100%'
			height: '100%'
			autoStyleContainer: false
	)