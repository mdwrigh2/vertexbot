auth  = require __dirname + '/authorized_users'
utils = require __dirname + '/../src/utils'

join = {
  action: 'command'
  reaction: (from, to, command, args) ->
    if command is "join"
      auth.is_authorized from, () =>
        chan = args.split()[0]
        this.join(chan)
}

part = {
  action: 'command'
  reaction: (from, to, command, args) ->
    if command is "part"
      auth.is_authorized from, () =>
        chan = args.split()[0]
        this.part(chan)
}

change_nick = {
  # We need to update the bots nick, and make sure any nick checks use
  # bot.nick and not cfg.nick
  action: 'command'
  reaction: (sender, respondee, command, args) ->
    if command is "nick"
      auth.is_authorized sender, () =>
        new_nick = args.split()[0]
        this.say respondee, "Changing my name to #{new_nick}"
        this.send 'NICK', new_nick
}

reload_plugins = {
  action: 'command'
  reaction: (sender, respondee, command, args) ->
    if command is "reload" and args.match(/plugins/i)
      auth.is_authorized sender, () =>
        this.say respondee, "Reloading plugins..."
        this.reload_plugins()
}

exports.events = [join, part, change_nick, reload_plugins]
