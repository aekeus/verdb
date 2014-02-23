cmds = require './cmds'
control = require './control'

exports.inject = (_control) ->
  control = _control

set_overrides =
  pointer: (nconf, k, v) ->
    batches = {}
    batches[batch] = 1 for batch in control.contents(nconf)
    if batches?[v]
      nconf.set "pointer", v
      console.log "batch pointer set to #{v}"
    else
      throw "unknown batch '#{v}'"

exports.run = (nconf, params, persist) ->
  throw "key required" unless params?[0]
  throw "value required" unless params?[1]

  k = params[0]
  v = params[1]

  if cmds.valid_setting(k)
    if set_overrides?[k]
      set_overrides[k](nconf, k, v)
    else
      nconf.set params[0], params[1]
      console.log "#{params[0]} set to #{params[1]}"
    persist nconf
  else
    console.log "invalid setting #{params[0]} - #{params[1]}"
  nconf