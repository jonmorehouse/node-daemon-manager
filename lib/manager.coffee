stream = require 'stream'
path = require 'path'
async = require 'async'
File = libRequire 'file'

class Manager extends stream.Readable

  constructor: (@paths, @opts, cb) ->
    super
    if typeof @opts == "function" and not cb?
      cb = @opts

    # set the base directory
    if not @opts.dir?
      @opts.dir = ".tmp"

    # normalize the paths so that they work properly for bootstrapping the various elements
    do @normalize
    @bootstrap cb

  _read: (size) ->
    _ = (file) =>
      file.on "data", (data) =>
        @push data

    _ file for file in @files

  bootstrap: (cb) ->
    @files = []
    _ = (obj, cb) =>
      obj.path = path.resolve path.join @opts.dir, obj.path
      file = new File obj.path, obj.msg, (err) ->
        cb()
      @files.push file

    async.each @paths, _, (err) ->
      return cb? err if err
      cb?()

  # normalize objectst that were passed for the @paths argument
  normalize: ->

    if not typeof @paths == "array"
      @paths = [@paths]

    _ = (obj) =>
      if typeof obj == "string"
        obj =
          path: obj 

      if not obj.msg?
        msg = path.basename obj.path
        obj.msg = if msg[0] == "." then msg.slice(1) else msg

      return obj

    @paths = (_ _path for _path in @paths)
  
  close: (cb) ->
    file.close() for file in @files
    cb?()

module.exports = Manager
