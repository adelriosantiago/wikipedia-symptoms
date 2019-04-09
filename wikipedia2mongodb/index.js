var Wiki = require("wikijs"),
  fs = require("fs"),
  readline = require("linebyline"),
  slugg = require("slugg"),
  MongoClient = require("mongodb").MongoClient,
  assert = require("assert");

var data = {},
  wiki = new Wiki();

var articles = []; //Array with disease names to fetch
var url = "mongodb://localhost:27017/bigdoc";

var rl = readline("./bulk.txt");
rl.on("line", function(line, lineCount, byteCount) {
  articles.push(line); //Do something with the line of text
})
  .on("error", function(e) {
    console.log("Error reading file");
  })
  .on("end", function(e) {
    console.log("End reading file");
    console.log(articles);

    MongoClient.connect(url, function(err, db) {
      assert.equal(null, err);
      console.log("Connected correctly to server");

      //Iterate over all articles
      articles.forEach(function(item) {
        var name = item
          .substr(item.lastIndexOf("/") + 1, item.length)
          .replace("_", " ");
        console.log("Wikiing article: " + name);
        wiki.page(name).then(function(page) {
          page.content().then(function(text) {
            if (text.length == 0) return;

            //TODO: Add a value { containsSymptoms : true|false } when the text contains "symptoms" or "signs"
            var dbEntry = {
              id: slugg(name),
              title: name,
              text: text,
              length: text.length,
              source: item,
              date: new Date()
            };

            //This will only insert if the entry does not exists: db.getCollection('diseases').update({length: 125212}, {$setOnInsert: {abc:10023}}, {upsert: true})

            var duplicateTest = { id: dbEntry.id, length: dbEntry.length };
            console.log("About to insert: " + name);
            db.collection("diseases").update(
              duplicateTest,
              { $setOnInsert: dbEntry },
              { upsert: true },
              function(err, result) {
                //Insert the document
                assert.equal(null, err);
                console.log("Inserted: " + name);
              }
            );
          });
        });
      });

      //Create index for text
      var collection = db.collection("diseases");
      collection.createIndex({ text: "text" }, function(err, result) {
        console.log(result);
        console.log("Index created");
      });
    });
  });