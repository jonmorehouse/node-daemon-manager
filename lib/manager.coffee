stream = require 'stream'
path = require 'path'
async = require 'async'
File = libRequire 'file'

class Manager extends stream.Readable

  constructor: (@paths, @opts, cb)->
  
    if typeof @opts == "function" and not cb?
      cb = @opts
      @opts = {}

    # normalize the paths so that they work properly for bootstrapping the various elements
    do @normalize
    @bootstrap cb

  bootstrap: (cb)->

    file = new File @paths[0].path, @paths[0].msg, cb

  normalize: ->

    if not typeof @paths == "array"
      @paths = [@paths]

    checkPath = (obj) =>
      if typeof obj == "string"
        obj =
          path: path.resolve path.basename obj 
      if not obj.msg?
        msg = path.basename obj.path
        obj.msg = if not msg[0] == "." then msg else msg[1:msg.length]
      return obj

    @paths = (checkPath _path for _path in @paths)

module.exports = Manager
