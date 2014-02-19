#!/usr/bin/env coffee
test = require('tap').test
set = require '../lib/reset'

test "set", (t) ->

  nconf =
    set: (k, v) ->
      t.equal k, 'pointer', 'pointer set'
      t.equal v, '', 'v set'

  persist = (_nconf) ->
    t.equal _nconf, nconf, "persist called with correct nconf"

  t.plan 3
  set.run nconf, persist
  t.end()
