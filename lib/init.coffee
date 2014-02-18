exports.run = (nconf, params, persist) ->
  throw "database name required as first parameter" unless params?[0]
  throw "user name required as second parameter" unless params?[1]
  throw "control file name as third parameter" unless params?[2]

  nconf.set "pointer", null
  nconf.set "database:host", 'localhost'
  nconf.set "database:name", params[0]
  nconf.set "database:user", params[1]
  nconf.set "control_file", params[2]
  nconf.set "up", "up.sql"
  nconf.set "down", "down.sql"

  persist nconf
