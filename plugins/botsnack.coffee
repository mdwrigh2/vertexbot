botsnack = {
  action: 'command'
  reaction: (sender, respondee, command, args) ->
    if command.toLowerCase() is "botsnack"
      this.say respondee, "Yum!"
}

exports.events = [botsnack]
