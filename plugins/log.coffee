db = (require './utils/db.coffee').db
Schema = db.Schema
ObjectId = Schema.ObjectId

Message =  new Schema({
  from: String,
  to: String,
  message: String,
  date: { type: Date, default: Date.now }
})

db.model('Message', Message)
MessageModel = db.model('Message')

logging = {
  action: 'message'
  reaction: (from, to, message) ->
    msg = new MessageModel()
    msg.from = from
    msg.to = to
    msg.message = message
    msg.save (err) ->
      if err
        console.log "Error logging message!"
        console.log err
}
exports.events = [logging]
