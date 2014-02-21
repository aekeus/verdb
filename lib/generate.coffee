trigger = require './generators/trigger'
table   = require './generators/table'
index   = require './generators/index'

exports.dispatch = (nconf, params) ->
  type = params?[0] or throw "type required"
  batch = params?[1] or throw "batch name required"
  
  switch type
    when 'trigger' then trigger.generate batch, params, nconf
    when 'table'   then table.generate batch, params, nconf
    when 'index'   then index.generate batch, params, nconf
    else
      throw "unknown type #{type}"
