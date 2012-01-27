twss = require 'twss'
auth = require __dirname+'/authorized_users'

twss.threshold = 0.9

twss_action = {
  action: 'message'
  reaction: (from, to, message) ->
    if to.match(new RegExp("#"))
      # Somebody sent it to a channel,
      # so respond to the channel and use their name
      ret = to
      prefix = "#{from}: "
    else
      # Otherwise respond directly to them
      # and there's no need to use their name
      ret = from
      prefix = ""
    if twss.is(message)
      this.say ret, prefix + "That's what she said!"
}

twss_threshold = {
  action: 'command'
  reaction: (sender, respondee, command, args) ->
    if command is "set" and args.match(/^twss threshold to /i)
      auth.is_authorized sender, () =>
        num = parseFloat(args.split(/\s/)[3])
        if num?
          twss.threshold = num
          this.say respondee, "Threshold set to " + num + "!"
        else
          this.say respondee, "Error setting threshold"
}

exports.events = [twss_action, twss_threshold]
