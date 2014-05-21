stream = require 'stream'
path = require 'path'
async = require 'async'
File = libRequire 'file'

class Manager extends stream.Readable

  constructor: (@args...) ->

    super
    @setEncoding "utf-8"
    @paths = []
    for arg, index in @args.reverse()
      switch 
        when typeof arg is "function" and index is 0 then cb = arg
        when typeof arg is "object" and index in [0, 1] then @opts = arg
        else
          @paths.push arg
    
    # normalizePaths the opts
    @opts ?= {}
    @opts.dir ?= ".tmp"

    # normalizePaths the paths so that they work properly for bootstrapping the various elements
    do @normalizePaths

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

  normalizePaths: ->

    @paths = if not @paths.length > 0 then ["stop"] else @paths

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
    @emit "close"
    cb?()

module.exports = Manager
