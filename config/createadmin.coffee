# Create Admin
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

mongoose = require('mongoose')
bcrypt = require('bcrypt')
salt = bcrypt.genSaltSync(10)
path = require('path')
root = path.dirname(__dirname)
yaml_file = "#{root}/config/app.yaml"
config = require('yaml-config')
settings = config.readConfig("#{yaml_file}")
hash = bcrypt.hashSync("#{process.env.npm_config_password}", salt)

mongoose.connect "#{settings.mongodb_uri}"
User = mongoose.model('User', {username: String, password: String, is_admin: Boolean})
admin = new User(username: "#{process.env.npm_config_admin}", password: "#{hash}", is_admin: true)

admin.save (err) ->
  if err
    console log "Error: #{err}"
    process.exit()
  else
    console.log "New Superuser #{process.env.npm_config_admin} created!"
    process.exit()
