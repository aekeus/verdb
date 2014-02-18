fs = require 'fs'

exports.inject = (_fs) ->
  fs = _fs

exports.filename = (nconf) ->
  nconf.get "control_file"

exports.contents = (nconf) ->
  control_file = nconf.get 'control_file'
  throw "control file #{control_file} not accessible" unless fs.existsSync control_file
  (cmd for cmd in fs.readFileSync(nconf.get('control_file'), 'utf-8').split(/\n/) when cmd.match(/^[a-zA-Z0-9_]+$/))
