# This is broken for multiple channels. Names is going to blow away the list of nicks for multiple channels everytime.
# The fix for this is creating an object with members that are the channels that contain a list of the nicks inside, and then having one
# member that contains all nicks online.
# This is probably done easiest with a function that iterates over all members of the object via isOwnProperty, rather than explicitly mangaing
# a list. If I do want to explicitly manage a list however, the only issue is the names events, and then I'd just have to calculate a difference
# between the current list and the new list to see what to remove from the channel. This could be pretty expensive though.
nick_names = []

names = {
    action: 'names'
    reaction: (channel, nicks) ->
        nick_names = for nick, blah of nicks
            nick
}

update_names_part = {
  action: 'part'
  reaction: (chan, nick) ->
    nick_names.filter((name) ->
      if name.match(nick)
        return false
      else
        return true
    )
}
update_names_quit = {
  action: 'quit'
  reaction: (nick, reason, channels) ->
    nick_names.filter((name) ->
      if name.match(nick)
        return false
      else
        return true
    )
}

update_names_kick = {
  action: 'kick'
  reaction: (channel, nick, kicker, reason)  ->
    nick_names.filter((name) ->
      if name.match(nick)
        return false
      else
        return true
    )
}

update_names_join = {
  action: 'join'
  reaction: (channel, nick) ->
    nick_names.push(nick)
}

is_online = (nick) ->
  # Just create a function that returns if the nick is on the irc channel. This maybe easiest
  for n in nick_names
    if nick == n
      return True
  return False

exports.nicks = is_online
exports.events = [names, update_names_part, update_names_quit, update_names_kick, update_names_join]
