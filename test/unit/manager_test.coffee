bootstrap = require "../bootstrap"
Manager = libRequire "manager"

module.exports = 

  setUp: (cb)->

    @input = [
      ".graceful",
      {
        path: "restart"
        msg: "restart"
      },
      {
        path: "kill"
      }
    ]
    cb?()

  test: (test)->

    @manager = new Manager @input, (err)->

    do test.done

