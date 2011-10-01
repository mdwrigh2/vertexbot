Client = (require 'irc').Client
utils = require __dirname+'/utils'
Emitter = (require 'events').EventEmitter
fs = require 'fs'

log_format = (from, to, message) ->
  return from + " => " + "to" + ": " + message

with_plugin_files = (dir, callback) ->
  fs.readdir dir, (err, files) ->
    for file in files
      do (file) ->
        fs.stat dir+'/'+file, (err, stats) ->
          if stats.isFile() and file.match(/\.coffee$/i) or file.match(/\.js$/i)
            callback file

class IRCBot extends Client
  constructor: (name, server, options) ->
    super(server, name, options)
    this.on 'message', (from, to, message) ->
      message = utils.trim(message)
      if message.match(new RegExp("^#{name}", 'i')) or to is name
        msg_split = (msg for msg in message.split(/\s/) when msg.length > 0)
        if message.match(new RegExp("^#{name}", 'i'))
          msg_split.shift() # Shift off the name, we no longer need it
          return_location = to
        else
          return_location = from
        command = msg_split.shift()
        args = message.substr(message.indexOf(command) + command.length)
        args = utils.trim args # We lose the spacing off the front of the args here. I'm okay with that
        this.emit 'command', from, return_location, command, args

  load_plugin: (plugin) ->
    for event in plugin.events
      this.on event.action, event.reaction

  load_plugins: (dir) ->
    this.plugins_dir = dir
    with_plugin_files dir, (file) =>
      try
        plugin = require "#{dir}/#{file}"
        for event in plugin.events
          this.on event.action, event.reaction
          this.plugin_events.push(event)
        console.log("Plugin loaded: #{file}")
      catch error
        console.log('Error loading plugin: ' + file)
        console.log error

  unload_plugins: (dir) ->
    with_plugin_files dir, (file) ->
      delete require.cache["#{dir}/#{file}"]

  reload_plugins: () ->
    for event in this.plugin_events
      this.removeListener event.action, event.reaction
    this.unload_plugins(this.plugins_dir)
    this.load_plugins(this.plugins_dir)

  plugin_events: []

  say: (name, msg) ->
    # 400 is purely a guess. I'd have to check the name and the padding for sending a message to determine what the actual
    # size is. I tried 450 and seemed to run into issues with it, however.
    while msg.length > 400
      sending = msg.substr(0, 400)
      msg = msg.substr(400)
      super(name, sending+"...")
    super(name, msg)

exports.IRCBot = IRCBot
