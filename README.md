Node Daemon Trigger
====================

Simple way to trigger exits/restarts for Node daemons in production

Example Usage
-------------

```
Trigger = require 'node-daemon-trigger'
trigger = {path: ".graceful", msg}
trigger = "/path"

manager = new Trigger [trigger], {dir: pwd}
manager = new Trigger trigger

manager.on "data", (data)->
  

```

