readline = require('linebyline')
Wiki = require('wikijs')
MongoClient = require('mongodb').MongoClient;
assert = require('assert')

console.log "Started"

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
	
url = 'mongodb://localhost:27017/bigdoc';

MongoClient.connect url, (err, db) ->
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
					
					console.log "Inserted: " + name + " with result ", result
		
		console.log "End"
###

#Routes
module.exports = (app, passport) ->
	
	#Bigdoc hompage
	app.get "/", (req, res) ->
		res.render "home.jade"
	
	#Original information page
	app.get "/info", (req, res) ->
		res.render("info.jade")
    
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
