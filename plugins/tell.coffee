db = (require __dirname+'/utils/db').db
utils = require __dirname+'/../src/utils'
Schema = db.Schema
ObjectId = Schema.ObjectId

Tell = new Schema({
  from: String,
  to: String,
  message: String,
  sent: { type: Boolean, default: false },
  date: { type: Date, default: Date.now }
})

db.model('Tell', Tell)
TellModel = db.model('Tell')

receive_tell = {
  action: 'command'
  reaction: (from, to, command, message) ->
    if command == "tell"
      t = new TellModel()
      t.from = from
      message = utils.trim(message)
      nick = message.match(/^[A-Za-z][A-Z|a-z|0-9|-|\[|\]|\\|`|\^|\{|\}]*/) # This is the nick from the RFC
      message = message.substr(message.indexOf(nick)+nick.length+1)
      message = utils.trim(message)
      t.to = nick
      t.message = message
      t.save (err) ->
        if err
          console.log "Error storing tell!"
          console.log t
          console.log err
}


tell_msg = (nick, channel) ->
  TellModel.find({name: nick, sent: false}, (err, tells) ->
    if err
      console.log "Error retrieving tell for #{nick}!"
      console.log err
    else
      for tell in tells
        this.say(channel, "Message from #{tell.from} (#{tell.date}): #{tell.message}")
        tell.sent = true
        tell.save (err) ->
          console.log "Message sent but error saving"
          console.log tell
          console.log err
  )
relay_tell_message = {
  action: 'message'
  reaction: (from, to, message) ->
    tell_msg(from, to)
}

relay_tell_join = {
  action: 'join'
  reaction: (channel, nick) ->
    tell_msg(nick, channel)
}

exports.events = [relay_tell_message, relay_tell_join, receive_tell]
