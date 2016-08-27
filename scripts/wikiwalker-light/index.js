var Wiki = require('wikijs'),
	fs = require('fs'),
	readline = require('linebyline'),
	MongoClient = require('mongodb').MongoClient,
    assert = require('assert');
    
var data = {},
	wiki = new Wiki();

var articles = []; //Array with disease names to fetch

var rl = readline('./bulk.txt');
rl.on('line', function(line, lineCount, byteCount) {
    articles.push(line); //Do something with the line of text
}).on('error', function(e) {
		console.log("Error reading file");
}).on('end', function(e) {
	console.log("End reading file");
	console.log(articles);
});

//Connection URL
var url = 'mongodb://localhost:27017/bigdoc';

MongoClient.connect(url, function(err, db) {
    assert.equal(null, err);
    console.log("Connected correctly to server");

    //Iterate over all articles
    var wiki = new Wiki();
    articles.forEach(function(item) {
        var name = item.substr(item.lastIndexOf('/') + 1, item.length).replace('_', ' ');
        console.log("Wikiing " + name);
        
        wiki.page(name).then(function(page) {
            page.content().then(function(text) {
                if (text.length == 0) return;
                
                //TODO: Add a value { containsSymptoms : true|false } when the text contains "symptoms" or "signs"
                
                var dbEntry = {_id : slugg(name), title: name, text : text};                
                
                console.log("About to insert " + name);
                (db.collection('diseases')).insert(dbEntry, function (err, result) { //Insert the document
                    if (err) return console.log(err);
                    console.log("Inserted " + name);
                });
            });
        });
    });
    
    //Create index for text
    var collection = db.collection('diseases');
    collection.createIndex({ text : "text" }, function(err, result) {
		console.log(result);
		console.log('Index created');
	});
});

//TODO: Implement these methods
//fetchAll()
//getTextSizes()