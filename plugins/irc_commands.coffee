auth = (require __dirname+'/authorized_users')
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

exports.events = [join, part]
