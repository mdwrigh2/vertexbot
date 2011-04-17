require.paths.unshift './src'
require.paths.unshift './plugins'

fs = require 'fs'

IRCBot = (require 'ircbot.coffee').IRCBot


cfg = (require './config.coffee').cfg

bot = new IRCBot cfg.name, cfg.server, { channels: cfg.channels }

fs.readdir('plugins', (err, files) ->
  for file in files
    do (file) ->
      fs.stat 'plugins/'+file, (err, stats) ->
        if stats.isFile() and file.match(/\.coffee$/i) or file.match(/\.js$/i)
          try
            bot.load_plugin (require file)
            console.log("Plugin loaded: #{file}")
          catch error
            console.log('Error loading plugin: ' + file)
            console.log error
      
)
