const wiki = require("wikijs").default,
  fs = require("fs"),
  readline = require("linebyline"),
  slugg = require("slugg"),
  MongoClient = require("mongodb").MongoClient,
  assert = require("assert");

const mongoUrl = "mongodb://localhost:27017/"; //Must containt ending slash

let articles = []; //Array with disease names to fetch
let rl = readline("./bulk.txt");

rl.on("line", function(line) {
  articles.push(line); //Do something with the line of text
})
  .on("error", function(e) {
    throw new Error("Error reading file", e);
  })
  .on("end", function(e) {
    console.log(`End reading bulk file. About to process ${ articles.length } lines.`);
    
    let storeTo = (articles.shift()).split(":");
    if (storeTo.length !== 2) {
      throw new Error("No database and collection specified. Bulk file must begin with a 'database:collection' line.");
      return;
    }
    let database = storeTo[0];
    let collection = storeTo[1];

    MongoClient.connect(mongoUrl, function(err, client) {
      assert.equal(err, null);
      const db = client.db(database);
      console.log("Connected to MongoDB");

      //Iterate over all articles
      articles.forEach(function(item) {
        let name = item
          .substr(item.lastIndexOf("/") + 1, item.length)
          .replace("_", " ");
          
        console.log("Wiki'ing article: " + name);
        wiki().page(name).then(function(page) {
          page.content().then(function(text) {
            if (text.length == 0) return;

            let dbEntry = {
              id: slugg(name),
              length: text.length,
              title: name,
              text: text,
              source: item,
              date: new Date(),
            };

            db.collection(collection).updateOne(
              { id: dbEntry.id }, //Only add the document if the id and the length are different
              { $set: dbEntry },
              { upsert: true },
              function(err, result) {
                assert.equal(err, null);
                if (result.modifiedCount) {
                  console.log(`Updated "${dbEntry.id}" in ${database}:${collection}`);
                } else {
                  console.log(`Document "${dbEntry.id}" in ${database}:${collection} was not updated`);
                }
              }
            );
          });
        });
      });
    });
  });