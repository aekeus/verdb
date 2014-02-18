colors = require 'colors'

control = require './control'
utils   = require './utils'

exports.run = (nconf, params) ->
  batches = control.contents nconf
  pointer = nconf.get 'pointer'
  idx = utils.index_of_batch batches, pointer
  if pointer and idx is -1
    throw "Invalid pointer name '#{pointer}' in config file - did a directory name change?".red
  if not pointer
    console.log "Empty current pointer indicates no batches installed yet".yellow
  for batch, idx in batches
    if pointer is batch
      console.log "---> ".green + "#{idx+1}.".grey + " #{batch}".green
    else
      console.log "     " + "#{idx+1}.".grey + " #{batch}"
