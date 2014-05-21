# Node Daemon Manager
> A simple way to control daemon processes remotely

## Usage

~~~ coffee-script
Trigger = require 'daemon-manager'
trigger = {path: ".graceful", msg}

manager = new Trigger [trigger], {dir: pwd}

manager.on "data", (data)->
  
  # a trigger has happened - handle accordingly
  # you can now shut down your application

# close all streams (once done)
manager.close()
```

