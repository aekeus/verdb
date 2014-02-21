#!/usr/bin/env coffee
test = require('tap').test
trg = require '../lib/generators/trigger'
tbl = require '../lib/generators/table'
idx = require '../lib/generators/index'

test "generate index", (t) ->
  t.plan 5
  nconf =
    get: (k) ->

  t.throws ->
    idx.generate "blah", [], nconf, ->
  , "table required"

  nconf =
    get: (k) ->
      switch k
        when table then 'instructors'

  t.throws ->
    idx.generate "blah", [], nconf, ->
  , "fields required"

  nconf =
    get: (k) ->
      switch k
        when "table" then "instructors"
        when "fields" then "a,b,c"

  utils =
    create_batch: (batch, up_buf, down_buf, nconf, cb) ->
      t.equal batch, "instructor-batch", "correct batch"
      t.equal up_buf, "CREATE INDEX instructors_a_b_c_idx ON instructors(a,b,c);", "create index"
      t.ok down_buf.match(/DROP INDEX instructors_a_b_c_idx;/), "drop index"

  idx.inject utils
  idx.generate "instructor-batch", [], nconf, ->

  t.end()

test "generate table", (t) ->
  t.plan 4
  nconf =
    get: (k) ->

  t.throws ->
    tbl.generate "blah", [], nconf, ->
  , "table required"

  nconf =
    get: (k) ->
      switch k
        when "table" then "students"

  utils =
    create_batch: (batch, up_buf, down_buf, nconf, cb) ->
      t.equal batch, "student-table", "correct batch"
      t.ok up_buf.match(/CREATE TABLE students/), "create table"
      t.ok down_buf.match(/DROP TABLE students/), "drop table"

  tbl.inject utils
  tbl.generate "student-table", [], nconf, ->
  
  t.end()

test "generate trigger", (t) ->
  t.plan 7

  nconf =
    get: (k) ->
      switch k
        when 'func' then 'log_student'
  t.throws ->
    trg.generate "blah", [], nconf, ->
  , "table required"

  nconf =
    get: (k) ->
      switch k
        when 'table' then 'foo'
  t.throws ->
    trg.generate "blah", [], nconf, ->
  , "func required"

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

  trg.inject utils
  trg.generate "student-trigger", [], nconf, ->
  t.end()
