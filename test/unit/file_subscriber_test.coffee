bootstrap = require "../bootstrap"
FileSubscriber = libRequire "file_subscriber"
path = require 'path'
touch = require 'touch'

subscriber = null

module.exports = 

  setUp: (cb)->

    bootstrap.setUp ->
      subscriber = new FileSubscriber()
      subscriber.setEncoding "utf-8"
      cb?()
  
  tearDown: (cb)->
    bootstrap.tearDown ->
      cb?() 

  test: (test)->

    subscriber.close()
    do test.done
    #subscriber.on "data", (data)->
      #p data
    #subscriber.on "end", (data)->
      #do test.done

