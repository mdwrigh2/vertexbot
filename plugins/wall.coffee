nick_names = []

names = {
    action: 'names'
    reaction: (channel, nicks) ->
        nick_names = for nick, blah of nicks
            nick
}


wall = {
  action: 'command'
  reaction: (from, to, command, args) ->
    now = new Date()
    if command is 'wall'
      msg = "Message from #{from} (#{now}): #{args}"
      this.say(name, msg) for name in nick_names
}

exports.events = [names, wall]
