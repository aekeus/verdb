#!/usr/bin/env coffee
test = require('tap').test
set = require '../lib/set'

test "set", (t) ->

  consol =
    log: (m) ->
      t.equal m, "pointer set to v"

  set.inject consol

  nconf =
    set: (k, v) ->
      t.equal k, 'pointer', 'pointer set'
      t.equal v, 'v', 'v set'

  persist = (_nconf) ->
    t.equal _nconf, nconf, "persist called with correct nconf"

  set.run nconf, ['pointer', 'v'], persist

  t.end()
