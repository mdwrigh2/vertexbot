Client = (require 'irc').Client
utils = require 'utils'
Emitter = (require 'events').EventEmitter

log_format = (from, to, message) ->
  return from + " => " + "to" + ": " + message

class IRCBot extends Client
  constructor: (name, server, options) ->
    super(server, name, options)
    this.on 'message', (from, to, message) ->
      message = utils.trim(message)
      if message.match(new RegExp("^#{name}", 'i'))
        msg_split = (msg for msg in message.split(/\s/) when msg.length > 0)
        msg_split.shift() # Shift off the name, we no longer need it
        command = msg_split.shift()
        args = message.substr(message.indexOf(command)+command.length)
        args = utils.trim(args) # We lose the spacing off the front of the args here. I'm okay with that
        this.emit('command', from, to, command, args)

  load_plugin: (plugin) ->
    for event in plugin.events
      this.on event.action, event.reaction

exports.IRCBot = IRCBot
