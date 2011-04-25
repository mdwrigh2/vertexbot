cfg = (require '../config.coffee').cfg

exports.trim = (string) ->
  return string.replace(/^\s*/, "").replace(/\s*$/, "")

exports.debug = (string) ->
  if cfg.debug
    console.log string
