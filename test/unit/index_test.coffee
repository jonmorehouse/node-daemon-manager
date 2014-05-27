bootstrap = require "../bootstrap"
index = libRequire "index"
path = require 'path'
cp = require 'child_process'

module.exports = 

  tearDown: (cb) ->

    @manager.close ->
      bootstrap.tearDown ->
        cb?()

  testManager: (test) ->

    @manager = new index.Manager (err) =>
      @manager.on "data", (data) =>
        test.equals data, "stop"
        do test.done

      command = "touch #{path.resolve path.join ".tmp", "stop"}"
      cp.exec command


