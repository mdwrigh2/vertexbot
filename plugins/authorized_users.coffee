db = (require __dirname+'/utils/db').db
cfg = (require __dirname+'/../config').cfg

Schema = db.Schema
ObjectId = Schema.ObjectId

AuthorizedUser = new Schema({
  name: String
  date: { type: Date, default: Date.now }
})

db.model('AuthorizedUser', AuthorizedUser)
AuthorizedUserModel = db.model('AuthorizedUser')

addAuthorized = {
  action: 'command'
  reaction: (from, to, command, message) ->
    if command is 'auth'
      if from is cfg.owner
        name = message.split(/\s+/).filter((x) -> return x)[0]
        AuthorizedUserModel.findOne {name: name}, (err, usr) =>
          if usr
            this.say(to, "Authorized User #{usr.name} was already authorized.")
          else
            usr = new AuthorizedUserModel()
            usr.name = name
            usr.save (err) =>
              if err
                this.say to, "Error adding authorized user!"
                console.log err
              else
                this.say to, "#{name} has been authorized"
      else
        this.say to, "You must be the owner to authorize users!"
        
}

removeAuthorized = {
  action: 'command'
  reaction: (from, to, command, message) ->
    if command is 'deauth'
      if from is cfg.owner
        name = message.split(/\s+/).filter((x) -> return x)[0]
        AuthorizedUserModel.findOne {name: name}, (err, usr) =>
          if usr
            usr.remove()
            this.say to, "Deauthorized user #{usr.name}."
          else
            this.say to, "#{name} is not an authorized user"
}

is_authorized = (nick, success, failure=()->) ->
  AuthorizedUserModel.findOne {name: nick}, (err, usr) =>
    if usr || nick is cfg.owner
      success()
    else
      failure()

exports.events = [addAuthorized, removeAuthorized]
exports.is_authorized = is_authorized
