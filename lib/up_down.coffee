temp   = require 'temp'
crypto = require 'crypto'
fs     = require 'fs'
async  = require 'async'
colors = require 'colors'
spawn  = require('child_process').spawn

utils   = require './utils'
control = require './control'
show    = require './show'

crypt = (text) -> crypto.createHash('md5').update(text).digest("hex")

args_for_psql = (nconf, temporary) ->
  args = ["-U#{nconf.get('database:user')}"]
  args.push "-h#{nconf.get('database:host')}" if nconf.get('database:host')
  args.push nconf.get('database:name')
  args.push "-f#{temporary}"
  args

batch_filename = (batch, direction, nconf) ->
  fn = if direction is 'up' then nconf.get("up") else nconf.get("down")
  "#{batch}/#{fn}"

apply_batch = (batch, direction, batches, nconf, persist, done) ->
  fn = batch_filename batch, direction, nconf
  console.log "applying #{batch} #{direction} from #{fn}"
  throw "batch file #{fn} does not exist" unless fs.existsSync fn
  batch_contents = fs.readFileSync fn, "utf-8"
  nconf.set "sets:#{batch}:#{direction}", crypt batch_contents
  batch_contents = """
DO $temp$
BEGIN
#{batch_contents}
END
$temp$;
  """
  temporary = temp.path()
  fs.writeFileSync temporary, batch_contents, "utf-8"

  args = args_for_psql nconf, temporary

  pg = spawn 'psql', args
  error = null
  buffer = ""
  pg.stdout.on 'data', (data) ->
    buffer += data.toString('utf-8')
  pg.stderr.on 'data', (data) ->
    e = data.toString('utf-8')
    error += e if e.match /ERROR/
  pg.on 'close', ->
    fs.unlinkSync temporary
    if not error
      if direction is "up"
        nconf.set "pointer", batch
      else
        idx = utils.index_of_batch batches, batch
        nconf.set "pointer", batches?[idx-1] or ""
      persist nconf
      show.run nconf
    done error

exports.run = (nconf, params, persist, direction) ->
  throw "invalid direction" unless direction is "up" or direction is "down"

  count = params?[0] or '1'
  all_batches = control.contents nconf
  pointer = nconf.get 'pointer'
  batches = utils.batches_to_apply all_batches, pointer, direction, count

  async.eachSeries batches, (batch, done) ->
    apply_batch batch, direction, all_batches, nconf, persist, done
  , (err) ->
    console.log err.red if err?
