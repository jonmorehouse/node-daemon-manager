path = require 'path'
bootstrap = require "../bootstrap"
fs = require 'fs'
sys = require 'sys'
cp = require 'child_process'
File = libRequire "file"

module.exports = 

  setUp: (cb)->

    @filepath = path.resolve baseDirectory, ".graceful"
    @file = new File @filepath, "graceful", (err)=>
      @file.setEncoding "utf-8"
      bootstrap.setUp ->
        cb?()

  tearDown: (cb)->

    @file.close()
    bootstrap.tearDown ->
      cb?()

  testListen: (test)->

    @file.on "data", (data)->
      p data
      do test.done

    handle = =>
      child = cp.spawn "touch", [@filepath]
      child.stdout.on "data", (chk)->
        p chk

    handle
    setTimeout handle, 2000

