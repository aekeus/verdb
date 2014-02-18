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
