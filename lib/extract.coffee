temp   = require 'temp'
_      = require 'underscore'
fs     = require 'fs'
common = require './common'
spawn  = require('child_process').spawn

stored_procedure = (nconf, params, done) ->
  throw "target required" unless params.length

  [schema, name] = params[0].split "."
  if not name?
    name = schema
    schema = 'public'

  STORED_PROCEDURE_QUERY = """
  SELECT row_to_json(row) FROM (
  select
    n.nspname                                   as schema_name,
    p.proname                                   as proc_name,
    pg_catalog.pg_get_function_result(p.oid)    as result_type,
    pg_catalog.pg_get_function_arguments(p.oid) as arg_types,
    p.prosrc                                    as src,
    l.lanname                                   as language
  FROM pg_catalog.pg_proc p
       LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
       LEFT JOIN pg_catalog.pg_language l ON l.oid = p.prolang
  WHERE p.proname ~ '^(#{name})$'
    AND n.nspname ~ '^(#{schema})$'
  LIMIT 1
  ) row
  """
  temporary = temp.path()
  fs.writeFileSync temporary, STORED_PROCEDURE_QUERY, "utf-8"

  args = common.args_for_psql nconf, temporary

  args.push '-Ptuples_only=1'

  pg = spawn 'psql', args
  error = null
  buffer = ""
  pg.stdout.on 'data', (data) ->
    buffer += data.toString('utf-8')
  pg.stderr.on 'data', (data) ->
    console.log "ERROR" + data.toString()
    e = data.toString('utf-8')
    error += e if e.match /ERROR/
  pg.on 'close', ->
    fs.unlinkSync temporary
    done error, buffer

build_stored_procedure = (spec) ->
  """
DROP FUNCTION #{spec.schema_name}.#{spec.proc_name}(#{spec.arg_types});
CREATE FUNCTION #{spec.schema_name}.#{spec.proc_name}(#{spec.arg_types}) RETURNS #{spec.result_type} AS $$#{spec.src}$$ LANGUAGE #{spec.language};
  """

# extractor functions
TYPES =
  sp: stored_procedure
  stored_procedure: stored_procedure
  function: stored_procedure

exports.run = (nconf, params) ->
  type = params.shift()
  throw "Invalid type '#{type}' for extraction. Valid types are '#{_.keys(TYPES).join(', ')}'" unless TYPES[type]?

  TYPES[type] nconf, params, (err, results) ->
    if err?
      throw err.toString()
    else
      console.log build_stored_procedure JSON.parse results
