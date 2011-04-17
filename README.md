An extensible IRC bot written in node.js

Requirements
============
  - node-irc
  - node-mongodb-native

Setup
=====
  First make sure you have node.js and npm installed. Then use npm to install coffeescript and node-irc and node-mongodb-native. Now just copy example-config.coffee to config.coffee and replace the config options with their appropriate values. Note that some of the plugins may be irc server dependent (mostly freenode). See the documentation for each plugin in order to determine which will work on what network if you aren't sure.

Plugins
=======
  Plugins are fairly simple to develop, just write the plugin and drop it into the 'plugins/' folder. Plugins should export a list of objects under the events variable, and each object should have an action member that contains a string for what event to react to, and a reaction member function that contains what to do when that event occurs. See the log.coffee plugin for an example.

Events
======
  Event: 'message'
  --------------
      function(from, to, message)
    Emitted when a message is sent in one of the channels the bot is currently residing in.
