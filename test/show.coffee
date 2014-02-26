 #!/usr/bin/env coffee
test = require('tap').test
show = require '../lib/show'

test "show one", (t) ->
  _control =
    contents: (nconf) ->
      ['a', 'b', 'c', 'd']

  _nconf =
    get: (k) ->
      switch k
        when 'up' then 'up.sql'
        when 'down' then 'down.sql'
        else throw "unknown key #{k}"

  _console =
    log: (text) ->
      t.ok text.length, "output received"

  _fs =
    readFileSync: (fn, encoding) ->
      t.equal fn, 'a/up.sql', 'correct filename'
      "CREATE TABLE foo ( a INTEGER );"

  show.inject _control, _console, _fs
  show.run _nconf, ['a', 'up']
  t.end()
