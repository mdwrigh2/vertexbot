cfg = (require '../../config.coffee').cfg
mongoose = require 'mongoose'



host = cfg.mongodb_host ? 'localhost'
port = cfg.mongodb_port ? 27017

mongoose.connect(host, 'vertexbot', port)

exports.db = mongoose
