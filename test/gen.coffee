#!/usr/bin/env coffee
test = require('tap').test
trg = require '../lib/generators/trigger'

test "generate trigger", (t) ->
  nconf =
    get: (k) ->
      switch k
        when 'table' then 'students'
        when 'func' then 'log_student'

  utils =
    create_batch: (batch, up_buf, down_buf, nconf, cb) ->
      t.equal batch, "student-trigger", "correct batch"
      t.ok up_buf.match(/CREATE TRIGGER students_trg/), "create trigger"
      t.ok up_buf.match(/CREATE FUNCTION log_student/), "create function"
      t.ok down_buf.match(/DROP TRIGGER students_trg ON students/), "drop trigger"
      t.ok down_buf.match(/DROP FUNCTION log_student/), "drop function"

  t.plan 5
  trg.inject utils
  trg.generate "student-trigger", [], nconf, ->
  t.end()
