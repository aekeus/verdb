fs = require 'fs'

exports.batches_to_apply = (batches, pointer, direction, count) ->
  if not pointer and direction is "down" then return []
  idx = batches.indexOf pointer
  count = parse_count count, batches
  if idx is -1
    if pointer
      throw "#{pointer} not found in batch names"

  if direction is "up"
    batches[idx+1..idx+count]
  else
    batches[idx+1-count..idx].reverse()

exports.index_of_batch = (batches, pointer) -> batches.indexOf pointer

exports.parse_count = parse_count = (count, batches) ->
  return batches.length if count is 'all'
  parseInt count

exports.persist = (nconf) ->
  nconf.save (err) ->
    throw err if err

exports.usage = ->
  console.log """

  verdb - transactional postgres DDL controller and generator

    init   - initialize new set of DDL files [databasename, username, control_filename]
    set    - set a parameter [parameter, value]
    status - show current status
    reset  - reset current pointer to first DDL batch
    up     - apply a set of forward DDL batches [count={all,integer}]
    down   - apply a set of backward DDL batches [count={all,integer}]
    show   - output contents of batch [{batch name|prev|NEXT}, {UP|down}]

    gen    - generate a batch and a database object

      gen trigger batch --table=students --func=add_student_log --trigger=students_trg
  """

exports.batch_filename = (batch, direction, nconf) ->
  fn = if direction is 'up' then nconf.get("up") else nconf.get("down")
  "#{batch}/#{fn}"

# create batch directory and append to control file
exports.create_batch = (batch, up_buf, down_buf, nconf, done) ->
  fs.mkdirSync batch
  fn = nconf.get "control_file"
  up = nconf.get "up"
  down = nconf.get "down"

  fs.appendFile fn, "\n" + batch, (err) ->
    fs.writeFileSync batch + "/" + up, up_buf
    fs.writeFileSync batch + "/" + down, down_buf
    done err
