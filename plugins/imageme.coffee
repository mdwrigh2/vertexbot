http = require 'http'
qs = require 'querystring'

imageme = {
  action: 'command'
  reaction: (sender, respondee, command, args) ->
    if command is 'imageme'
      query = qs.stringify { q:args, tbm:'isch' }
      options = {
        #https://www.google.com/search?q=foo&tbm=isch
        host: 'www.google.com',
        port: 80,
        path: "/search?#{query}"
      }
      http.get options, (res) =>
        pageData = ""
        res.on 'data', (chunk) =>
          pageData += chunk
        res.on 'end', () =>
          imgs = pageData.match /imgurl=[^&]*&/ig
          imgs = (item.trim() for item in imgs)
          imgs = (item.substr(7, item.length-8) for item in imgs)
          this.say respondee, "#{sender}: #{imgs[Math.floor(Math.random() * imgs.length)]}"

}

exports.events = [imageme]
