db = (require __dirname+'/utils/db').db
cfg = (require __dirname+'/../config').cfg
utils = require __dirname+'/../src/utils'
Schema = db.Schema
ObjectId = Schema.ObjectId

Tell = new Schema({
  from: String,
  to: String,
  message: String,
  sent: { type: Boolean, default: false },
  date: { type: Date, default: Date.now }
  pm: { type: Boolean, default: false }
})

db.model('Tell', Tell)
TellModel = db.model('Tell')

format_date = (date) ->
  str = ""
  str += "0" if date.getDate() < 10
  str += "#{date.getDate()}/"
  str += "0" if date.getMonth()+1 < 10
  str += "#{date.getMonth()+1}/#{date.getFullYear()} @ "
  str += "0" if date.getHours() < 10
  str += "#{date.getHours()}:"
  str += "0" if date.getMinutes() < 10
  str += "#{date.getMinutes()}:"
  str += "0" if date.getSeconds() < 10
  str += "#{date.getSeconds()}"
  return str




receive_tell = {
  action: 'command'
  reaction: (from, to, command, message) ->
    if command == "tell" or command == "pm"
      t = new TellModel()
      if command == "pm"
        t.pm = true
      t.from = from
      message = utils.trim(message)
      nick = message.match(/^[A-Z|a-z|0-9|-|\[|\]|\\|`|\^|\{|\}|\_]+/)[0] # This is the nick from the RFC
      message = message.substr(message.indexOf(nick)+nick.length+1)
      message = utils.trim(message)
      t.to = nick
      t.message = message
      t.save (err) =>
        if err
          console.log "Error storing tell!"
          console.log t
          console.log err
        else
          this.say(to, "#{from}, I'll tell #{t.to}")
}


relay_tell_message = {
  action: 'message'
  reaction: (from, to, message) ->
    TellModel.find {to: from, sent: false}, (err, tells) =>
      if err
        console.log "Error retrieving tell for #{from}!"
        console.log err
      else
        for tell in tells
          date_string = format_date(tell.date)
          msg = "#{tell.to}, message from #{tell.from} (#{date_string}): #{tell.message}"
          # If this tell is supposed to be a PM or if it the message
          # is sent to the bot in a PM, then respond in a PM.
          if tell.pm or to is cfg.name
            this.say(tell.to, msg)
          else
            this.say(to, msg)
          tell.sent = true
          tell.save (err) ->
            if err
              console.log "Message sent but error saving"
              console.log tell
              console.log err

}

relay_tell_join = {
  action: 'join'
  reaction: (channel, nick) ->
    TellModel.find({to: nick, sent: false}, (err, tells) =>
      if err
        console.log "Error retrieving tell for #{nick}!"
        console.log err
      else
        for tell in tells
          date_string = format_date(tell.date)
          msg = "#{nick}, message from #{tell.from} (#{date_string}): #{tell.message}"
          if tell.pm
            this.say(nick, msg)
          else
            this.say(channel, msg)
          tell.sent = true
          tell.save (err) ->
            if err
              console.log "Message sent but error saving"
              console.log tell
              console.log err
    )
}

exports.events = [relay_tell_message, relay_tell_join, receive_tell]
