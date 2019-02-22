shuffle = (a) ->
  a = [a...]
  len = a.length
  for i in [len-1...0] by -1
    r = (Math.random() * (i+1)) | 0
    tmp = a[i]
    a[i] = a[r]
    a[r] = tmp
  a

memoize = (fn) ->
  cache = new Map
  (args...) ->
    value = cache.get(args)
    if value is undefined
      value = fn(args...)
      cache.set args
      value
    value

int = (f) -> f | 0

readlines = (filename, cb) -> new Promise (resolve) ->
  if filename == '-'
    rs = process.stdin
  else
    rs = require('fs').createReadStream filename
    if filename.endsWith '.gz'
      rs = rs.pipe require('zlib').createGunzip()
  rl = require('readline').createInterface rs
  rl.on 'line', (line) -> cb line
  rl.on 'close', -> resolve()

gzwriter = (filename) ->
  if filename == '-'
    process.stdout
  else
    ws = require('fs').createWriteStream filename
    if filename.endsWith '.gz'
      gz = require('zlib').createGzip()
      gz.pipe ws
      gz
    else
      ws

lru_cache = (max) ->
  cache = {}
  head = {}
  head.prev = head.next = head
  n = 0
  hit = 0
  miss = 0
  evict = 0

  remove = (item) ->
    item.next.prev = item.prev
    item.prev.next = item.next

  insert = (item) ->
    item.prev = head
    item.next = head.next
    head.next.prev = item
    head.next = item

  put: (key, data) ->
    item = cache[key]
    if item
      remove item
    else
      if n >= max
        evict += 1
        last = head.prev
        remove last
        delete cache[last.key]
      else
        n++

    item = {key, data}
    insert item
    cache[key] = item

  get: (key) ->
    item = cache[key]
    unless item
      miss += 1
      return null
    hit += 1
    if item != head.next
      remove item
      insert item
    item.data

  stats: ->
    {n, hit, miss, evict}

round_value = (value) -> Math.round(value * 1e4) / 1e4

INFINITY = 1<<30

unique_moves = (board, me, moves=null) ->
  {encode_normalized} = require './encode'
  moves or= board.list_moves(me)
  codes = {}
  result = []
  for move in moves
    flips = board.move me, move
    code = encode_normalized(board)
    board.undo me, move, flips
    unless codes[code]
      codes[code] = true
      result.push move
  result

watch_file = (filename) ->
  fs = require 'fs'
  get_mtime = ->
    if fs.existsSync(filename)
      fs.statSync(filename).mtime.getTime()
    else
      null
  last_mtime = get_mtime()
  ->
    mtime = get_mtime()
    if mtime != last_mtime
      last_mtime = mtime
      true
    else
      false

module.exports = {
  shuffle
  memoize
  int
  readlines
  gzwriter
  lru_cache
  round_value
  INFINITY
  unique_moves
  watch_file
}
