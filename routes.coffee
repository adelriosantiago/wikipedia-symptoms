# App Routes
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>


readline = require('linebyline')
Wiki = require('wikijs')
MongoClient = require('mongodb').MongoClient;
assert = require('assert')
articles = []

rl = readline('./bulk.txt')

module.exports = (app, passport) ->

  # Basic
  app.get "/", (req, res) ->
    res.render("home.jade")



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

  # Imports
  require('./entities/users/controller')(app)
