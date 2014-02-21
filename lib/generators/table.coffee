fs = require 'fs'
utils = require '../utils'

up_template = """
CREATE TABLE __TABLE__ (
  
);

"""

down_template = """
DROP TABLE __TABLE__;

"""

exports.inject = (_utils) ->
  utils = _utils

exports.generate = (batch, params, nconf) ->
  table_name    = nconf.get("table")   or throw "table required"

  up_buf = up_template
  up_buf = up_buf.replace '__TABLE__', table_name

  down_buf = down_template
  down_buf = down_buf.replace '__TABLE__', table_name

  utils.create_batch batch, up_buf, down_buf, nconf, (err) ->
    console.log err if err?
