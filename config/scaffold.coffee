# Scaffold Generator
# MEAN Boilerplate by @Jmlevick <http://jmlevick.me>
# License: Coffeeware <https://github.com/Jmlevick/coffeeware-license>

fs = require('fs-extra')
path = require('path')
replace = require('replace')

root = path.dirname(__dirname)
name = "#{process.env.npm_config_plural.toLowerCase()}"
mvc_scaffold = path.join(root, "scaffolds/entities/dummies")
mvc_dest =  path.join(root, "entities/#{name}")
views_scaffold = path.join(root, "scaffolds/views/dummies")
views_dest = path.join(root, "views/entity_views/#{name}")
routes_file = "#{root}/routes.coffee"
routes_scaffold = "  require('./entities/#{name}/controller')(app)"


String::capitalizeFirstLetter = ->
  @charAt(0).toUpperCase() + @slice(1)

scaffolder = (singular, plural) ->
  fs.copy "#{mvc_scaffold}", "#{mvc_dest}", (err) ->
    if err
      console.error(err)
      process.exit()
    else
      fs.copy "#{views_scaffold}", "#{views_dest}", (err) ->
        if err
          console.error(err)
          process.exit()
        else
          fs.appendFile "#{routes_file}", "#{routes_scaffold}", (err) ->
            if err
              console.error(err)
              process.exit()
            else
              replace
                regex: 'Dummy'
                replacement: "#{singular.capitalizeFirstLetter()}"
                paths: [ "#{mvc_dest}", "#{views_dest}" ]
                recursive: true
                silent: true
              replace
                regex: 'Dummies'
                replacement: "#{plural.capitalizeFirstLetter()}"
                paths: [ "#{mvc_dest}", "#{views_dest}" ]
                recursive: true
                silent: true
              replace
                regex: 'dummy'
                replacement: "#{singular.toLowerCase()}"
                paths: [ "#{mvc_dest}", "#{views_dest}" ]
                recursive: true
                silent: true
              replace
                regex: 'dummies'
                replacement: "#{plural.toLowerCase()}"
                paths: [ "#{mvc_dest}", "#{views_dest}" ]
                recursive: true
                silent: true
              console.log "Successfully generated scaffold #{name}!"
              process.exit()

scaffolder("#{process.env.npm_config_singular}", "#{process.env.npm_config_plural}")
