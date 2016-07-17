var Wiki = require('wikijs'),
	fs = require('fs'),
	readline = require('linebyline'),
	MongoClient = require('mongodb').MongoClient,
    assert = require('assert');
    
var data = {},
	wiki = new Wiki();

wiki.page('Kane').then(function(page) {
	page.content().then(function(info) {
		data = info;
		console.log(data); //Bruce Wayne
		res.render('index', { title: 'Express', data: data});
	});
});

/*
//All the diseases
var articles = [];

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
//Use connect method to connect to the server
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
                var dbEntry = {"_id" : name, "text" : text};
                console.log(dbEntry);
                
                //Get the documents collection
                var diseases = db.collection('diseases');            
                //Insert some documents

                console.log("About to insert " + name);

                diseases.insert(dbEntry, function (err, result) {                
                    if (err) {
                        return console.log(err);
                    }

                    console.log("Inserted " + name);
                });
            });
        });
    });
});*/
