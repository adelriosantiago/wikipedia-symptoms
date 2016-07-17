var express = require('express');
var router = express.Router();
var http = require('http');
var Wiki = require('wikijs');
var fs = require('fs');
var readline = require('linebyline');

var MongoClient = require('mongodb').MongoClient,
    assert = require('assert');

//All the diseases
var articles = [];

var rl = readline('./bulk.txt');
rl.on('line', function(line, lineCount, byteCount) {
    //Do something with the line of text
    articles.push(line);
})
.on('error', function(e) {
    console.log("Error reading file");
    //Something went wrong
}).on('end', function(e) {
    //Something went wrong
    console.log("End reading file");
    console.log(articles);
});

//Old style no longer used
/*fs.readFile('./bulk.txt', 'utf8', function (err, data) {
    if (err) {
        return console.log(err);
    }
    console.log(data);
    
    var regex = /\[\[(.+?)\]\]/g;
    console.log(regex);
    var result;

    while (result = regex.exec(data)) {
        console.log(result[1]);
        if (result[1].indexOf('|') !== -1) {
            var fixedResult = result[1].substr(0, result[1].indexOf('|'));
            console.log("contains |, going to " + fixedResult);
        }
    }
});*/

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
});

/* GET home page. */
router.get('/', function(req, res, next) {
    /*var options = {
        hostname: 'en.wikipedia.org',
        path: '/wiki/Phase_velocity'
    };
    console.log('doing request');
    var request = http.request('http://en.wikipedia.org/wiki/Phase_velocity', function(res) {
        var data = '';
        console.log('inside request');
        
        res.on('data', function(chunk) {
            console.log('data in');
            data += chunk;
        });
        res.on('end', function() {
            console.log('end');
            console.log(data);
        });
    });
    request.on('error', function (e) {
        console.log(e.message);
    });
    request.end();*/
    
    var data = {};
    wiki.page('Kane').then(function(page) {
        page.content().then(function(info) {
            data = info;
            console.log(data); //Bruce Wayne
			res.render('index', { title: 'Express', data: data});
        });
    });
});

module.exports = router;