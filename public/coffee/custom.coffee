# Bigdoc big data symptom analysis by @adelriosantiago
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>

window.thecloud = null;
window.drawfunc = null;
window.wordsMatch = null;

$ ->
    #TODO: Implement word quantity by slider
    $('#cloudCount').slider {
        formatter : (value) ->
            return "abc: " + value
        }
    
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
    
    $("#symptoms").keyup((ev) -> filter_diseases())
    
    #The D3 wordcloud
    fill = d3.scale.category20();
    
    window.thecloud = d3.layout.cloud()
        .size [300, 300]
        .words [".NET", "Silverlight", "jQuery", "CSS3", "HTML5", "JavaScript", "SQL","C#"].map (d) -> 
            return {text: d, size: 10 + Math.random() * 50};
        .rotate ->
            return ~~(Math.random() * 2) * 90;
        .font "Impact"
        .fontSize (d) -> 
            return d.size;
        .on "end", draw
        .start();

    console.dir window.thecloud
    
    #TODO: Change the following code to CS!
    `
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
    `
