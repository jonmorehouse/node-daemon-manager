path = require 'path'
bootstrap = require "../bootstrap"
fs = require 'fs'
sys = require 'sys'
cp = require 'child_process'
File = libRequire "file"

module.exports = 

  setUp: (cb)->

    @filepath = path.resolve path.join ".tmp", ".graceful"
    @file = new File @filepath, "graceful", (err)=>
      @file.setEncoding "utf-8"
      bootstrap.setUp ->
        cb?()

  tearDown: (cb)->

    @file.close()
    bootstrap.tearDown ->
      cb?()

  testListen: (test)->

    @file.on "data", (data)=>
      test.equals "graceful", data
      do test.done

    child = cp.spawn "touch", [@filepath]


