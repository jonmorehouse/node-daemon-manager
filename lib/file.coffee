stream = require 'stream'
path = require 'path'
touch = require 'touch'
fs = require 'fs.extra'

# hash to representing all of the files
files = {}

class File extends stream.Readable

  # how long to wait to make sure that the fs.watch is running and activated ...
  @throttle = 200

  constructor: (@filepath, @msg, cb) ->
    super
    @bootstrap (err) =>
      @watch =>
        # watch the single file here
        cb?()

  _read: (size) ->
  watch: (cb) ->

    # lets set up a watch script here ...
    fs.watch @filepath, {persistent: false}, (event) =>
      if event? and not @stopped?
        @push @msg

    setTimeout cb, File.throttle 

  bootstrap: (cb) ->
    dir = path.dirname @filepath
    # make sure that the file exists
    _ = => 
      touch @filepath, (err) ->
        return cb? err if err
        cb?()

    fs.exists dir, (exists) ->
      if not exists
        fs.mkdirp dir, (err) ->
          _()
      else
        _()

  close: ->

    @stopped = true
    fs.unwatchFile @filepath
    @push null

class Wrapper extends stream.PassThrough

    constructor: (@filepath, @msg, cb) ->
      super 
      do @normalize 

      finish = =>  
        files[@filepath].pipe @
        cb?()

      # grab the file (try at least)
      file = files[@filepath]
      if not files[@filepath]?
        files[@filepath] = new File @filepath, @msg, (err) =>
          file = files[@filepath]
          do finish
      else
        do finish  

    normalize: ->

      @filepath = path.resolve @filepath
      # fill in a message if not passed
      if not @msg?
        @msg = @filepath

    close: ->
      if files[@filepath]?
        files[@filepath].close()
        delete files[@filepath]

    @close: ->

      file.close() for filepath, file of files

module.exports = Wrapper
