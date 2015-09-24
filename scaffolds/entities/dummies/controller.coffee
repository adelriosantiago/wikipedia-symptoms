# The Controller
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

module.exports = (app) ->

  # Model & YAML Loading
  Dummy = require('./model')
  config = require('yaml-config')
  settings = config.readConfig('config/app.yaml')

  # Index


  # Show


  # New


  # Create


  # Edit


  # Update


  # Destroy


  # Admin
  app.get "/dummies/admin", (req, res, next) ->
    if req.user? and req.user.is_admin is true
      Dummy.find().exec (err, dummies) ->
        return next(err)  if err
        res.render("entity_views/dummies/admin.jade", {dummies: dummies})
    else
      res.render('login.jade')
