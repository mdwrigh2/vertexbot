lmgtfy = {
  action: 'command'
  reaction: (from, to, command, args) ->
    if command is 'lmgtfy'
        q = args.split(' ')
        this.say(to, 'http://lmgtfy.com/?q='+q.join('+'))
    else if command is 'lmgtf'
        q = args.split(' ')
        this.say(to, q.splice(0,1)+':'+' http://lmgtfy.com/?q='+q.join('+'))
}

exports.events = [lmgtfy]
