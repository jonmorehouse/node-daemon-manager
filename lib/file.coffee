stream = require 'stream'
path = require 'path'
touch = require 'touch'
nodewatch = require 'nodewatch'

# hash to representing all of the files
files = {}

nodewatch.onChange (filepath, prev, curr, action)=>

  filepath = path.resolve filepath
  file = files[filepath]
  if not file?
    if error? and error.write?
      error.write new Error "Invalid path being watched"
  else
    file.write action

class File extends stream.Duplex

  constructor: (@filepath, @msg, cb)->

    super
    @bootstrap (err)=>
      # watch the single file here
      nodewatch.add @filepath
      cb?()

  _read: (size)->


  _write: (chk, enc, cb)->
    
    @push chk
    cb?()

  bootstrap: (cb)->

    # make sure that the file exists
    touch @filepath, (err)->
      return cb? err if err
      cb?()

  close: ->

    nodewatch.remove @filepath
    @push null

class Wrapper extends stream.PassThrough

    constructor: (@filepath, @msg, cb)->

      @filepath = path.resolve @filepath
      super 

      # fill in a message if not passed
      if not @msg?
        @msg = @filepath

      # grab the file (try at least)
      file = files[@filepath]
      if not files[@filepath]?
        files[@filepath] = new File @filepath, @msg, (err)=>
          file = files[@filepath]
          file.pipe @
          cb?()
      
      else
        # pipe the origin to this
        file.pipe @
        cb?()

    close: ->
      if files[@filepath]?
        files[@filepath].close()
        delete files[@filepath]

    @close: ->

      nodewatch.clearListeners()

module.exports = Wrapper
