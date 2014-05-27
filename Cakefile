nodeunit = require 'nodeunit'
{spawn} = require 'child_process'
{print} = require 'sys'

task "test", "Run all tests", ->

  reporter = nodeunit.reporters.verbose
  reporter.run ["test/unit"]

task "build", "Compile coffee-script to javascript", ->

  coffee = spawn 'coffee', ['-c', '-o', 'js', 'lib']
  coffee.stderr.on 'data', (data)->

  coffee.stdout.on 'data', (data)->
    print data.toString()

