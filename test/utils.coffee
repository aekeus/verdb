#!/usr/bin/env coffee
test = require('tap').test
utils = require '../lib/utils'

test "batches to apply", (t) ->
  batches = ['a', 'b', 'c', 'd', 'e']
  t.deepEqual utils.batches_to_apply(batches, "", "down", 0), [], "down with no pointer"

  t.deepEqual utils.batches_to_apply(batches, "", "up", "all"), batches, "initial up all"

  t.deepEqual utils.batches_to_apply(batches, "a", "up", 1), ['b'], "up 1 valid"
  t.deepEqual utils.batches_to_apply(batches, "a", "up", 2), ['b', 'c'], "up 2 valid"
  t.deepEqual utils.batches_to_apply(batches, "a", "up", 'all'), ['b', 'c', 'd', 'e'], "up all valid"
  t.deepEqual utils.batches_to_apply(batches, "e", "up", 1), [], "up at end valid"

  t.deepEqual utils.batches_to_apply(batches, "a", "down", 1), ['a'], "down 1 valid"
  t.deepEqual utils.batches_to_apply(batches, "c", "down", 2), ['c', 'b'], "down 2 valid"
  t.deepEqual utils.batches_to_apply(batches, "e", "down", 'all'), ['e', 'd', 'c', 'b', 'a'], "down all valid"

  t.end()

test "index of pointer", (t) ->
  batches = ['a', 'b', 'c', 'd', 'e']
  t.equal utils.index_of_batch(batches, 'b'), 1, 'first index found'
  t.equal utils.index_of_batch(batches, 'a'), 0, 'zeroth index found'
  t.equal utils.index_of_batch(batches, 'e'), 4, 'last index found'
  t.equal utils.index_of_batch(batches, 'z'), -1, 'index not found'

  t.end()

test "parse_count", (t) ->
  batches = ['a', 'b', 'c', 'd', 'e']

  t.equal utils.parse_count('all', batches), 5, 'all'
  t.equal utils.parse_count('3', batches), 3, 'integer input'

  t.end()

test "persist", (t) ->
  nconf =
    save: (done) ->
      t.ok true, "persist calls nconf save"

  t.plan 1
  utils.persist nconf
  t.end()

test "usage", (t) ->
  t.ok utils.usage?, "usage exists"
  t.end()

test "batch_filename", (t) ->
  nconf =
    get: (k) ->
      switch k
        when "up"   then "up.sql"
        when "down" then "down.sql"

  t.equal utils.batch_filename("batch", "up", nconf), "batch/up.sql", "batch up"
  t.equal utils.batch_filename("batch", "down", nconf), "batch/down.sql", "batch down"

  t.end()
