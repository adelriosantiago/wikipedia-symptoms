var Wiki = require('wikijs'),
	fs = require('fs'),
	readline = require('linebyline'),
	MongoClient = require('mongodb').MongoClient,
    assert = require('assert');
    
var data = {},
	wiki = new Wiki();

wiki.page('Kane').then(function(page) {
	page.content().then(function(info) {
		console.log(info); //Bruce Wayne
		console.log('Wikipedia fetch test finished');
	});
});


