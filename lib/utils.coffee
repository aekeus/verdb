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

  verdb - transactional postgres DDL controller

    init   - initialize new set of DDL files [databasename, username, control_filename]
    set    - set a parameter [parameter, value]
    status - show current status
    reset  - reset current pointer to first DDL batch
    up     - apply a set of forward DDL batches [count={all,integer}]
    down   - apply a set of backward DDL batches [count={all,integer}]
    show   - output contents of batch [{batch name|prev|NEXT}, {UP|down}]
  """

exports.batch_filename = (batch, direction, nconf) ->
  fn = if direction is 'up' then nconf.get("up") else nconf.get("down")
  "#{batch}/#{fn}"
