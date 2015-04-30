#!/usr/bin/env coffee
test = require('tap').test
extract = require '../lib/extract'

test "signature", (t) ->
  t.ok extract.run?, "has run function"
  t.end()