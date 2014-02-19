fs     = require 'fs'
colors = require 'colors'

control = require './control'
utils   = require './utils'

exports.run = (nconf, params) ->
  batch = params?[0] or 'next'
  direction = params?[1] or 'up'
  batches = control.contents nconf

  if batch is 'next'
    batch = nconf.get "pointer"
    idx = utils.index_of_batch batches, batch
    if idx + 1 is batches.length
      throw "at last batch already - try using prev".red
    else
      batch = batches[idx + 1]
  else if batch is 'prev'
    batch = nconf.get "pointer"
    if not batch
      throw "no installed batches - try using next".red
  else
    idx = utils.index_of_batch batches, batch
    if idx is -1
      throw "batch #{batch} does not exist".red

  fn = utils.batch_filename batch, direction, nconf
  contents = fs.readFileSync fn, 'utf-8'

  console.log fn.green
  console.log contents

  