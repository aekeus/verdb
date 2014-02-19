colors = require 'colors'
trigger = require './generators/trigger'

exports.dispatch = (nconf, params) ->
  type = params?[0] or throw "type required"
  batch = params?[1] or throw "batch name required"
  
  switch type
    when 'trigger' then trigger.generate batch, params, nconf
    else
      throw "unknown type #{type}".red
