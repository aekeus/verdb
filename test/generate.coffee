#!/usr/bin/env coffee
test = require('tap').test
trg = require '../lib/generate'

test "dispatch", (t) ->
  nconf =
    get: (k) ->
  
  t.throws ->
    trg.dispatch nconf, []
  , "type required"

  t.throws ->
    trg.dispatch nconf, ['trigger']
  , "batch required"

  t.throws ->
    trg.dispatch nconf, ['foobar']
  , "unknown type foobar"

  t.end()
