#!/usr/bin/env coffee
test = require('tap').test
cmds = require '../lib/cmds'

test "valid settings", (t) ->
  t.ok cmds.valid_setting("pointer"), "valid setting"
  t.notOk cmds.valid_setting("pointerFoo"), "invalid setting"
  t.end()
