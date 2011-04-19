lmgtfy = {
  action: 'command'
  reaction: (from, to, command, args) ->
    if command is 'lmgtfy'
        q = args.split(' ')
        qf = []
        qf.push(encodeURIComponent(arg)) for arg in q
        this.say(to, 'http://lmgtfy.com/?q='+qf.join('+'))
    else if command is 'lmgtf'
        q = args.split(' ')
        qf = []
        qf.push(encodeURIComponent(arg)) for arg in q
        this.say(to, qf.splice(0,1)+':'+' http://lmgtfy.com/?q='+qf.join('+'))
}

exports.events = [lmgtfy]
