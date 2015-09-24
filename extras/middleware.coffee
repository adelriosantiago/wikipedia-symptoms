# Your own middleware goes here...
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

express = require('express')

module.exports = (app) ->
  app.use((req, res, next) ->
    if req.user?
      res.locals.current_user = req.user["username"]
    else
      res.locals.current_user = 'guest'
    next())
