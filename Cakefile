require "./test/bootstrap"
nodeunit = require 'nodeunit'

task "test", "Run all tests", ->

  reporter = nodeunit.reporters.verbose
  reporter.run ["test/unit"]

task "debug", "Temporary development helper", ->
  
  bootstrap = libRequire "file"

  boot = new bootstrap ".graceful"
  boot.setEncoding "utf-8"

  boot.on "data", (data)->

    p data
    boot.close()


