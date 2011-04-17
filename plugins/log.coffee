logging = {
  action: 'message'
  reaction: (from, to, message) ->
    console.log(from + " => " + to + ": " + message)
}
exports.events = [logging]
