fs = require 'fs'
utils = require '../utils'

up_template = """
CREATE FUNCTION __FUNCTION__() RETURNS TRIGGER AS $$
BEGIN
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER __TRIGGER_NAME__ AFTER UPDATE OR INSERT ON __TABLE__ FOR EACH ROW
EXECUTE PROCEDURE __FUNCTION__();

"""

down_template = """
DROP TRIGGER __TRIGGER_NAME__ ON __TABLE__;
DROP FUNCTION __FUNCTION__();

"""

exports.inject = (_utils) ->
  utils = _utils

exports.generate = (batch, params, nconf, persist) ->
  table_name    = nconf.get "table"    or throw "table required"
  function_name = nconf.get "func"     or throw "func required"
  trigger_name  = nconf.get("trigger") or "#{table_name}_trg"

  up_buf = up_template
  up_buf = up_buf.replace new RegExp('__FUNCTION__', 'gi'), function_name
  up_buf = up_buf.replace '__TRIGGER_NAME__', trigger_name
  up_buf = up_buf.replace '__TABLE__', table_name

  down_buf = down_template
  down_buf = down_buf.replace new RegExp('__FUNCTION__', 'gi'), function_name
  down_buf = down_buf.replace '__TRIGGER_NAME__', trigger_name
  down_buf = down_buf.replace '__TABLE__', table_name

  utils.create_batch batch, up_buf, down_buf, nconf, (err) ->
    console.log err if err?
