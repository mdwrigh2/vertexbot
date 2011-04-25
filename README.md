An extensible IRC bot written in node.js

Requirements
============
  - node-irc
  - mongoose

Setup
=====
  First make sure you have node.js and npm installed. Then use npm to install coffeescript and node-irc and mongoose. Now just copy example-config.coffee to config.coffee and replace the config options with their appropriate values. Note that some of the plugins may be irc server dependent (mostly freenode). See the documentation for each plugin in order to determine which will work on what network if you aren't sure.

Plugins
=======
  Plugins are fairly simple to develop, just write the plugin and drop it into the 'plugins/' folder. Plugins should export a list of objects under the events variable, and each object should have an action member that contains a string for what event to react to, and a reaction member function that contains what to do when that event occurs. See the log.coffee plugin for an example.

Events
======
  This is a list of the events emitted by the bot. Note that most of the commands are actually emitted from node-irc, so see there for further documentation on events.

Event: 'command'
--------------
      function(from, to, command, args)

  Emitted when a command is issued to the bot. Commands are anything where the bot is directly told something, and the args is just a string with everything after the command issued. For example, the message "bot: do something awesome" would have the command "do" and the args "something awesome".


Event: 'message'
--------------
      function(from, to, message)

  Emitted when a message is sent in one of the channels the bot is currently residing in.

Event: 'message#channel'
--------------
      function(from, message)

  Emitted when a message is sent to the specified channel.

Event: 'motd'
-------------
    function(motd)

Event: 'names'
-------------
    function(channel, nicks)

Event: 'topic'
-------------
    function(channel, topic, nick)

Event: 'join'
-------------
    function(channel, nick)

Event: 'join#channel'
-------------
    function(nick)

Event: 'part'
-------------
    function(channel, nick)

Event: 'part#channel'
-------------
    function(nick, reason)

Event: 'quit'
-------------
    function(nick, reason, channels)

Event: 'kick'
-------------
    function(channel, nick, by, reason)

Event: 'kick#channel'
-------------
    function(nick,by,reason)

Event: 'notice'
-------------
    function(nick, to, text)

Event: 'pm'
-------------
    function(channel, nick)

Event: 'nick'
-------------
    function(oldnick, newnick, channels)
  
Event: 'raw'
-------------
    function(message)

Event: 'error'
-------------
    function(message)
