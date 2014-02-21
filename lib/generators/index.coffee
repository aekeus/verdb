fs = require 'fs'
utils = require '../utils'

exports.inject = (_utils) ->
  utils = _utils

exports.index_name = (nconf, table, fields) ->
  if nconf.get("index")
    nconf.get("index")
  else
    "#{table}_#{fields.replace(new RegExp(',','gi'), '_')}_idx"

exports.generate = (batch, params, nconf) ->
  table_name = nconf.get("table")   or throw "table required"
  fields     = nconf.get("fields")  or throw "fields required"
  name       = exports.index_name(nconf, table_name, fields)

  up_buf = "CREATE INDEX #{name} ON #{table_name}(#{fields});"
  down_buf = "DROP INDEX #{name};"

  utils.create_batch batch, up_buf, down_buf, nconf, (err) ->
    console.log err if err?
