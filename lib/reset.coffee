exports.run = (nconf, persist) ->
  nconf.set "pointer", ""
  persist nconf
