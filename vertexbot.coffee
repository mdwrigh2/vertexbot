require.paths.unshift './src'
require.paths.unshift './plugins'

IRCBot = (require 'ircbot.coffee').IRCBot


cfg = (require 'example-cfg.coffee').cfg

bot = new IRCBot cfg.name, cfg.server, { channels: cfg.channels }
