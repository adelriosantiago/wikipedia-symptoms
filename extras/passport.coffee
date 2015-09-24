# PassportJS
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

module.exports = (passport, LocalStrategy, User) ->

  passport.serializeUser (user, done) ->
    done null, user.id
    return
  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      done err, user
      return
    return

  bcrypt = require('bcrypt')
  salt = bcrypt.genSaltSync(10)

  validatePassword = (password, hash) ->
    bcrypt.compareSync(password, hash)

  passport.use new LocalStrategy((username, password, done) ->
    User.findOne { username: username }, (err, user) ->
      if err
        return done(err)
      if !user
        return done(null, false, message: 'Incorrect username.')
      if !validatePassword(password, user.password)
        return done(null, false, message: 'Incorrect password.')
      done null, user
    return
  )
