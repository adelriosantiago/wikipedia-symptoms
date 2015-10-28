#TODO: Solve the DB not closing

readline = require('linebyline')
Wiki = require('wikijs')
MongoClient = require('mongodb').MongoClient;
assert = require('assert')

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
					
					#TODO: Important to close db
					console.log "Inserted: " + name + " with result ", result
		
		console.log "End"
###

#Routes
module.exports = (app, passport) ->
	
	#Bigdoc hompage
	app.get "/", (req, res) ->
		res.render "home.jade"

	#Bigdoc API get diagnose
	app.get "/api/diagnose", (req, res) ->
		#TODO: Sanitize query.symptoms entry

		symptoms = req.query.symptoms

		#TODO: Perform the DB text search
		MongoClient.connect mongoDBUrl, (err, db) ->
			diseases = db.collection 'diseases'

			((diseases.find {$text : {$search : symptoms}}, {"score" : {$meta : "textScore"}, "text" : 0}).sort {"score" : {$meta : "textScore"}}).toArray((err, docs) ->
				assert.equal null, err
				console.dir(docs)
				#response = {symptoms: symptoms, result: docs}
				#res.render "home.jade", {response: JSON.stringify response, null, 4}
				res.json({symptoms: symptoms, result: docs})
				#TODO: Close DB!
				#BUG: Close DB!
				return
			)

	#Bigdoc API get info
	app.get "/api/info", (req, res) ->
		res.json "{db_status:null, db_entries:null}"

	#Original information page
	app.get "/info", (req, res) ->
		res.render "info.jade"

	###
	# Passport Auth
	app.get "/login", (req, res) ->
		res.render("login.jade")

		app.get "/test", (req, res) ->
		res.render("login.jade")

	app.get '/logout', (req, res) ->
		req.logout()
		req.flash('passport-success-logout', 'Logged out successfully!')
		res.redirect '/'

	app.post '/login', passport.authenticate('local'), (req, res) ->
		redirection_url = if  req.headers.referer.indexOf('/login') is -1 then req.headers.referer else '/'
		req.flash('passport-success-login', 'Logged in successfully!')
		res.redirect(redirection_url)
	###

	#Imports
	require('./entities/users/controller')(app)
