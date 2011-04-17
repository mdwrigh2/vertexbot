exports.events = [{action: 'message', reaction: (from, to, message) -> console.log(from + " => " + to+": "+message)}]
