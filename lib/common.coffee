exports.args_for_psql = (nconf, temporary) ->
  args = ["-U#{nconf.get('database:user')}"]
  args.push "-h#{nconf.get('database:host')}" if nconf.get('database:host')
  args.push nconf.get('database:name')
  args.push "-f#{temporary}"
  args
