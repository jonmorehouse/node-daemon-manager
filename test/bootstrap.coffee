path = require 'path'
async = require 'async'
fs = require 'fs.extra'


# 
global.baseDirectory = path.resolve path.join __dirname, ".."
global.conn = null
global.p = console.log
global.libRequire = (_path) ->
  return require path.join baseDirectory, "lib", _path

setUpFunctions = {}

tearDownFunctions = 

  files: (cb) ->
    fs.rmrf ".tmp", (err) ->
      cb?()

exports.setUp = (cb) ->
  async.waterfall (_function for key, _function of setUpFunctions), (err) ->
    cb?()

exports.tearDown = (cb) ->
  async.waterfall (_function for key, _function of tearDownFunctions), (err) ->
    cb?()

