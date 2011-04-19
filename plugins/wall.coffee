nick_names = []

names = {
    action: 'names'
    reaction: (channel, nicks) ->
        console.log(nicks)
        nick_names = for nick, blah of nicks
            nick
        console.log(nick_names)
}


wall = {
  action: 'command'
  reaction: (from, to, command, args) ->
    if command is 'wall'
        this.say(name, args) for name in nick_names
        console.log()
}

exports.events = [names, wall]
