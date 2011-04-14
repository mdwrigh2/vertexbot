var irc = require('irc');
var fs = require('fs')

var file_stream = fs.createWriteStream('log.txt')

process.on('SIGINT', function(){
  console.log("Caught SIGINT. Closing file descriptors")
  file_stream.destroy()
  file_stream.end()
  });

var client = new irc.Client('irc.freenode.net', 'nodebottle', {
  channels: ['#bottest'],
  });



client.addListener('message', function(from, to, message) {
  write = file_stream.write(from + ' => '+ to + ':' + message+'\n');
  console.log(write);
});
