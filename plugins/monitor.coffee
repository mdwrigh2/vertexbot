cfg = (require __dirname+'/../config').cfg
db = (require __dirname+'/utils/db').db
is_online = (require __dirname+'/current_users').is_online


Schema = db.Schema
ObjectId = Schema.ObjectId

OwnerMention = new Schema({
  from: String,
  to: String,
  message: String,
  seen: {type: Boolean, default: false },
  date: {type: Date, default: Date.now}
})

db.model('OwnerMention', OwnerMention)
OwnerMentionModel = db.model('OwnerMention')

monitor = {
  action: 'message'
  reaction: (from, to, message) ->
    if message.match(new RegExp(cfg.owner)) and not is_online(cfg.owner)
      om = new OwnerMentionModel()
      om.from = from
      om.to = to
      om.message = message
      om.save (err) ->
        if err
          console.log "Error Logging Mention!"
          console.log om
          console.log err
}




exports.events = [monitor]
