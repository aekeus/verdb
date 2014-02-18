colors = require 'colors'
control = require './control'

exports.run = (nconf, params) ->
  cmds = control.contents nconf
  pointer = nconf.get 'pointer'
  for cmd, idx in cmds
    if pointer is cmd
      console.log "---> ".green + "#{idx+1}.".grey + " #{cmd}".green
    else
      console.log "     " + "#{idx+1}.".grey + " #{cmd}"
