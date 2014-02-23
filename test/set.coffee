#!/usr/bin/env coffee
test = require('tap').test
set = require '../lib/set'

test "set", (t) ->

  nconf =
    set: (k, v) ->
      t.equal k, 'up', 'pointer set'
      t.equal v, 'bar', 'v set'

  persist = (_nconf) ->
    t.equal _nconf, nconf, "persist called with correct nconf"

  t.plan 3
  set.run nconf, ['up', 'bar'], persist
  t.end()

test "set pointer override", (t) ->
  persist = (nconf) ->
    t.ok 1, "persist called"

  control =
    contents: (nconf) ->
      t.ok 1, "contents called"
      ['a', 'b', 'c']

  nconf =
    set: (k, v) ->
      t.equal k, 'pointer', 'pointer set'
      t.equal v, 'b', 'pointer value set'

  t.plan 6

  set.inject control
  t.throws ->
    set.run nconf, ['pointer', 'd'], persist
  , "unknown batch 'd'"

  set.run nconf, ['pointer', 'b'], persist

  t.end()
