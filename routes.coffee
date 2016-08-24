#TODO: Solve the DB not closing

readline = require('linebyline')
Wiki = require('wikijs')
MongoClient = require('mongodb').MongoClient;
assert = require('assert')
_ = require('lodash')

console.log "Started"
mongoDBUrl = 'mongodb://localhost:27017/bigdoc';

###
articles = []
rl = readline('./bulk.txt')
rl.on "line", (line, lineCount, byteCount) ->
    articles.push(line)
    return
rl.on "error", (e) ->
	console.log("Error reading file")

rl.on "end", (e) ->
	console.log("End reading file")

MongoClient.connect mongoDBUrl, (err, db) ->
	assert.equal null, err
	console.log "Connected to the server"
	
	wiki = new Wiki();

	articles.forEach (item) ->
		name = item.substr((item.lastIndexOf '/') + 1, item.length).replace '_', ' '
		console.log "Wikiing: " + name
		
		(wiki.page name).then (page) ->
			page.content().then (text) ->
				dbEntry = {"_id" : name, "text" : text}
				console.log dbEntry.name
		
				#Insert the entry on the DB
				diseases = db.collection 'diseases'
				console.log "About to insert: " + name
				
				diseases.insert dbEntry, (err, result) ->
					return console.log err if err
					
					#TODO: Close db
					console.log "Inserted: " + name + " with result ", result
		
		console.log "End"
###

#Routes
module.exports = (app, passport) ->

    #Bigdoc hompage
    app.get "/", (req, res) ->
        res.render "home.jade"

    #Bigdoc API get diagnose
    app.get "/recalculate-sizes", (req, res) ->
        MongoClient.connect mongoDBUrl, (err, db) ->
            if err
                console.log "Error"
                console.log err
            
            
            
            res.json {status: "Done"}
            db.close()
            return
        
    
    #Bigdoc API get diagnose
    app.get "/api/diagnose", (req, res) ->
        #TODO: Sanitize query.symptoms entry

        symptoms = req.query.symptoms
        limit = req.query.limit #TODO: Convert to int and erase the next line
        limit = 15 #Hardcoded limit

        MongoClient.connect mongoDBUrl, (err, db) ->
            if err
                console.log "Error"
                console.log err
        
            diseases = db.collection 'diseases'
            diseases.aggregate([
                {$match: {$text: {$search: symptoms}}},
                #{$project: {"_id" : 0, "key" : "$_id", value: {$multiply : [{ $meta: "textScore" }, 10]}}}, #Old version, no longer used
                {$project: {"_id" : 0, "key" : "$_id", value: { $meta: "textScore" }}},
                {$sort: {score: {$meta: "textScore" }}},
                {$limit: limit}
            ]).toArray((err, docs) ->
                assert.equal err, null
                console.log "DOC:" + JSON.stringify docs
                
                #Make scores go from 0.0 to 1.0
                dMax = docs[0].value
                dMin = docs[docs.length - 1].value
                dDiff = dMax - dMin
                dFactor = 1 / dDiff
                #TODO: Fix scores in accordance to text quantity
                
                
                #Draw words for each value
                docs.forEach (item) ->
                    console.log item.value
                    item.value = (item.value - dMin) * dFactor #Convert to 0 to 1 scale
                    item.value = item.value + 0.3 #Avoid 0 size words
                    item.value = item.value * 10 #Scale words for the word cloud
                    
                

                res.json {diseases: docs, symptoms: symptoms}
                db.close()
                return
            );

    #Bigdoc API get info
    app.get "/api/info", (req, res) ->
        res.json "{db_status:null, db_entries:null}"
     
    #TO-DO: Uncomment when we have no more mistakes loading resources (these resources reach this route)
    ##All else (this route *must* be last on this file!)
    #app.get "*", (req, res) ->
    #    res.redirect "/"