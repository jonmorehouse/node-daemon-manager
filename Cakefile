nodeunit = require 'nodeunit'

task "test", "Run all tests", ->

  reporter = nodeunit.reporters.verbose
  reporter.run ["test/unit"]

task "debug", "Temporary development helper", ->
  
  bootstrap = libRequire "bootstrap"
  bootstrap.bootstrap (err, ready)->


