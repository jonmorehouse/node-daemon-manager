stream = require 'stream'
path = require 'path'


class Manager extends stream.Readable

  constructor: (@paths, @opts)->
  
    if not typeof @paths == "array"
      @paths = [@paths]

    if not @opts? 
      @opts = {}

    if not @opts.dir?
      @dir = path.dirname require.main.filename
    else
      @dir = @opts.dir


