// Generated by CoffeeScript 1.10.0
(function() {
  var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  window.thecloud = null;

  window.drawfunc = null;

  window.wordsMatch = null;

  $(function() {
    var connectorStr, fill, filter_diseases, relevantStr;
    connectorStr = ['the', 'and', 'or'];
    relevantStr = ['pain', 'coughing', 'sneezing'];
    (filter_diseases = function() {
      var filtered, i, len, outString, symptoms, word;
      outString = $("#symptoms").val().replace(/[`~!@#$%^&*()_|+\=?;:'",.<>\{\}\[\]\\\/]/gi, ' ');
      symptoms = outString.split(/[\s,]+/);
      filtered = [];
      for (i = 0, len = symptoms.length; i < len; i++) {
        word = symptoms[i];
        if (indexOf.call(connectorStr, word) >= 0) {
          filtered.push('<span class="connector">' + word + '</span>');
        } else if (indexOf.call(relevantStr, word) >= 0) {
          filtered.push('<span class="relevant">' + word + '</span>');
        } else {
          filtered.push(word);
        }
      }
      return $("#filtered-symptoms").html(filtered.join(','));
    })();
    $("#symptoms").keyup(function(ev) {
      return filter_diseases();
    });
    fill = d3.scale.category20();
    window.thecloud = d3.layout.cloud().size([300, 300]).words([".NET", "Silverlight", "jQuery", "CSS3", "HTML5", "JavaScript", "SQL", "C#"].map(function(d) {
      return {
        text: d,
        size: 10 + Math.random() * 50
      };
    })).rotate(function() {
      return ~~(Math.random() * 2) * 90;
    }).font("Impact").fontSize(function(d) {
      return d.size;
    }).on("end", draw).start();
    console.dir(window.thecloud);
    return 
	function draw(words) {
		d3.select("#wordcloud")
		.append("svg")
		.attr("width", 300)
		.attr("height", 300)
		.append("g")
		.attr("transform", "translate(150,150)")
		.selectAll("text")
		.data(words)
		.enter().append("text")
		.style("font-size", function(d) { return d.size + "px"; })
		.style("font-family", "Impact")
		.style("fill", function(d, i) { return fill(i); })
		.attr("text-anchor", "middle")
		.attr("transform", function(d) {
			return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
		})
		.text(function(d) { return d.text; });
	}
	;
  });

}).call(this);