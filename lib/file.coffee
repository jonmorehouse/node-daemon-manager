stream = require 'stream'
path = require 'path'
touch = require 'touch'
watch = require 'nodewatch'

# hash to representing all of the files
files = {}

class File extends stream.Readable

  constructor: (@path, @msg)->

    if not @msg? 
      @msg = path.filename @path

  _read: (size)->

    # watch the single file here
    watch.add @path, 

  bootstrap: (cb)->

    # make sure that the file exists
    touch @path, (err)->

      p err


  close: ->

    @push null


class FileWrapper extends stream.Passthrough


    constructor: (@path, @msg)->
      if not files[@path]?
        files[@path] = new File @path, @msg

      files[@path].pipe @

    close:
      if files[@path]?
        files[@path].close()
        delete files[@path]

