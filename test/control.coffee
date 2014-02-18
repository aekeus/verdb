 #!/usr/bin/env coffee
test = require('tap').test
control = require '../lib/control'

test "filename", (t) ->
  nconf =
    get: (k) ->
      t.equals k, "control_file", "proper key passed to filename"
      t.end()

  control.filename nconf

mock_file_contents = """
a

b

"""

test "contents", (t) ->
  nconf =
    get: (k) ->
      t.equals k, "control_file", "proper key passed to filename"
      "control.txt"

  fs =
    existsSync: (control_file) ->
      t.equals control_file, "control.txt", "correct filename"
      true
    readFileSync: (control_file, encoding) ->
      t.equals control_file, "control.txt", "correct filename"
      t.equals encoding, "utf-8", "correct encoding"
      mock_file_contents

  control.inject fs
  contents = control.contents nconf
  t.deepEqual contents, ['a', 'b'], "correc contents"
  t.end()
