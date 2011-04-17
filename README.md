An extensible IRC bot written in node.js

Requirements
------------
  - node-irc
  - node-mongodb-native

Plugins
-------
  Plugins are fairly simple to develop, just write the plugin and drop it into the 'plugins/' folder. Plugins should export a list of objects under the events variable, and each object should have an action member that contains a string for what event to react to, and a reaction member function that contains what to do when that event occurs. See the log.coffee plugin for an example.
