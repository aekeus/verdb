cmds = require './cmds'

exports.inject = (_console) ->
  console = _console

exports.run = (nconf, params, persist) ->
  throw "key required" unless params?[0]
  throw "value required" unless params?[1]

  if cmds.valid_setting(params[0])
    nconf.set params[0], params[1]
    console.log "#{params[0]} set to #{params[1]}"
    persist nconf
  else
    console.log "invalid setting #{params[0]} - #{params[1]}"
  nconf