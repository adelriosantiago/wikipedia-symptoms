# The Model
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

mongoose = require('mongoose')
config = require('yaml-config')
settings = config.readConfig('config/app.yaml')

Schema = mongoose.Schema
db = mongoose.createConnection(settings.mongodb_uri)

UsersSchema = new Schema({
  username: String,
  password: String,
  is_admin: Boolean
})

module.exports = db.model('User', UsersSchema)
