bootstrap = require "../bootstrap"
Manager = libRequire "manager"
path = require 'path'
cp = require 'child_process'

module.exports = 

  setUp: (cb) ->
    @input = "graceful" 
    cb?()

  tearDown: (cb) ->
    @manager.close ->
      bootstrap.tearDown ->
        cb?()

  test: (test) ->
    @manager = new Manager @input, (err) =>
      @manager.on "data", (data) ->
        test.equals data, "graceful"
        do test.done

      command = "touch #{path.resolve path.join ".tmp", "graceful"}"
      cp.exec command

  testDefaults: (test) ->

    @manager = new Manager (err) =>
      @manager.on "data", (data) ->
        test.equals data, "stop"
        do test.done

      command = "touch #{path.resolve path.join ".tmp", "stop"}"
      cp.exec command


    
