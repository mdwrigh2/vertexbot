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
    if command is 'wall'
        this.say(name, args) for name in nick_names
}

exports.events = [names, wall]
