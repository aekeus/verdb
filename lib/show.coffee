fs     = require 'fs'
colors = require 'colors'

control = require './control'
utils   = require './utils'

exports.inject = (_control, _console, _fs) ->
  control = _control
  console = _console
  fs = _fs

show_one = (batch, direction, nconf) ->
  fn = utils.batch_filename batch, direction, nconf
  contents = fs.readFileSync fn, 'utf-8'

  console.log "-- " + fn
  console.log contents

show_many = (batches, direction, nconf) ->
  dfn = if direction is "up" then nconf.get("up") else nconf.get("down")
  for batch in batches
    fn = "#{batch}/#{dfn}"
    contents = fs.readFileSync fn, 'utf-8'
    console.log "-- " + fn
    console.log contents

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
      show_one batch, direction, nconf
  else if batch is 'prev'
    batch = nconf.get "pointer"
    if not batch
      throw "no installed batches - try using next".red
    show_one batch, direction, nconf
  else if batch is 'all'
    batches = batches.reverse() if direction is "down"
    show_many batches, direction, nconf
  else
    idx = utils.index_of_batch batches, batch
    if idx is -1
      throw "batch #{batch} does not exist".red
    show_one batch, direction, nconf
