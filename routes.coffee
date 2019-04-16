MongoClient = require('mongodb').MongoClient;
assert = require('assert')
slugg = require('slugg')
_ = require('lodash')

console.log "Started"
mongoDBUrl = 'mongodb://localhost:27017/';

#Routes
module.exports = (app, passport) ->

	#Bigdoc hompage
	app.get "/", (req, res) ->
		res.render "index.jade"
	
	#Bigdoc API get diagnose
	app.get "/api/diagnose", (req, res) ->
		#TODO: Sanitize query.symptoms entry

		symptoms = req.query.symptoms
		limit = +req.query.limit
		if limit > 30
			limit = 30

		MongoClient.connect mongoDBUrl, (err, client) ->
			if err
				throw new Error err
		
			db = client.db "medicine"
			
			(db.collection 'diseases').aggregate([
				{ $match: { $text: { $search: symptoms } } },
				#{$project: {"_id" : 0, "key" : "$_id", value: {$multiply : [{ $meta: "textScore" }, 10]}}}, #Old version
				{ $project: { "_id" : 0, "key" : "$id", value: { $meta: "textScore" } } },
				{ $sort: { score: { $meta: "textScore" } } },
				{ $limit: limit }
			]).toArray((err, docs) ->
				assert.equal err, null
				
				if !_.isEmpty docs
					#Make scores go from 0.0 to 1.0
					dMax = docs[0].value
					dMin = docs[docs.length - 1].value
					dDiff = dMax - dMin
					dFactor = 1 / dDiff
					#TODO: Fix scores in accordance to text quantity
					
					#Draw words for each value
					docs.forEach (item) ->
						item.value = (item.value - dMin) * dFactor #Convert to 0 to 1 scale
						item.value = item.value + 0.3 #Avoid 0 size words
						item.value = item.value * 10 #Scale words for the word cloud

				res.json { diseases: docs, symptoms: symptoms }
				client.close()
				return
			);

	#Bigdoc API get info
	app.get "/api/info", (req, res) ->
		res.json "{ db_status: null, db_entries: null }"
	 
	#TO-DO: Uncomment when we have no more missing loading resources (these resources reach this route)
	##All else (this route *must* be last on this file!)
	#app.get "*", (req, res) ->
	#	res.redirect "/"