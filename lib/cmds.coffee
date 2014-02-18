exports.valid_setting = (v) ->
  o =
    "pointer": true
    "database:host": true
    "database:name": true
    "database:user": true
    "control_file": true
    "up": true
    "down": true
  o?[v]
