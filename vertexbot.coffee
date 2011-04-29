fs = require 'fs'
repl = require 'repl'

IRCBot = (require __dirname+'/src/ircbot.coffee').IRCBot


try
  cfg = (require __dirname+'/config.coffee').cfg
catch error
  console.log "Error loading config! Are you sure it's in the right place?"

bot = new IRCBot cfg.name, cfg.server, { channels: cfg.channels }

# Log the bot in
bot.on('motd', () ->
  if cfg.password
    bot.say('NickServ', "IDENTIFY #{cfg.password}")
)



bot.on('error', (error) ->
  console.log error
)

bot.load_plugins(__dirname+'/plugins')



r = repl.start()
r.context.bot = bot
r.context.cfg = cfg
