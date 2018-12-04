{ pos_from_xy, ALL_POSITIONS, Board, BLACK, WHITE, EMPTY } = require './board'
{ memoize, int } = require './util'

N_PHASES = 10
N_MOVES_PER_PHASE = 60 / N_PHASES

all_one = (len) -> (3 ** len - 1) / 2

reverse_index = (index, len) ->
  reverse = (sum, i, n) ->
    if n
      reverse(3*sum + (i % 3), int(i / 3), n - 1)
    else
      sum
  offset = all_one(len)
  reverse(0, index + offset, len) - offset

reverse_index_xy = (index, len) ->
  w = Math.sqrt(len)
  console.assert w == int(w)
  offset = all_one(len)
  index += offset

  array = for j in [0...len] by 1
    cell = index % 3
    index = int(index / 3)
    cell

  reversed = []
  for x in [0...w] by 1
    for i in [x...len] by w
      reversed.push array[i]

  result = 0
  for i in [len-1..0] by -1
    result *= 3
    result += reversed[i]

  result - offset

normalize = (fn, len, i) ->
  r = fn(i, len)
  if Math.abs(r) <= Math.abs(i) then r else i

normalize_map = memoize (fn, len) ->
  map = new Map
  for i in [0...3**len]
    map.set i, normalize(fn, len, i)
    map.set -i, normalize(fn, len, -i)
  map

flip_h = (positions) -> [7-x, y] for [x, y] in positions
flip_v = (positions) -> [x, 7-y] for [x, y] in positions
flip_xy = (positions) -> [y, x] for [x, y] in positions

flip_hv = (positions) -> [
  positions
  flip_h positions
  flip_v positions
  flip_v flip_h positions
]

flip_vxy = (positions) -> [
  positions
  flip_v positions
  flip_xy positions
  flip_xy flip_v positions
]

flip_v_only = (positions) -> [
  positions,
  flip_v positions,
]

flip_hvxy  = (positions) -> [
  positions
  flip_v positions
  flip_xy positions
  flip_xy flip_v positions
  flip_h positions
  flip_h flip_v positions
  flip_h flip_xy positions
  flip_h flip_xy flip_v positions
]

patterns = [
    name: 'corner3x3'
    positions: do ->
      result = []
      for x in [0..2]
        for y in [0..2]
          result.push [x, y]
      result
    reverse: reverse_index_xy
    flip: flip_hv
  ,
    name: 'corner2x5'
    positions: do ->
      result = []
      for x in [0..1]
        for y in [0..4]
          result.push [x, y]
      result
    reverse: (x) -> x
    flip: flip_hvxy
  ,
    name: 'edge2x'
    positions: do ->
      result = []
      result.push [1, 1]
      for x in [0..7]
        result.push [x, 0]
      result.push [6, 1]
      result
    reverse: reverse_index
    flip: flip_vxy
  ,
    name: 'hv2'
    positions: [x, 1] for x in [0..7]
    reverse: reverse_index
    flip: flip_vxy
  ,
    name: 'hv3'
    positions: [x, 2] for x in [0..7]
    reverse: reverse_index
    flip: flip_vxy
  ,
    name: 'hv4'
    positions: [x, 3] for x in [0..7]
    reverse: reverse_index
    flip: flip_vxy
  ,
    name: 'diag4'
    positions: [x, 3-x] for x in [0..3]
    reverse: reverse_index
    flip: flip_hv
  ,
    name: 'diag5'
    positions: [x, 4-x] for x in [0..4]
    reverse: reverse_index
    flip: flip_hv
  ,
    name: 'diag6'
    positions: [x, 5-x] for x in [0..5]
    reverse: reverse_index
    flip: flip_hv
  ,
    name: 'diag7'
    positions: [x, 6-x] for x in [0..6]
    reverse: reverse_index
    flip: flip_hv
  ,
    name: 'diag8'
    positions: [x, 7-x] for x in [0..7]
    reverse: reverse_index
    flip: flip_v_only
  ,
    name: 'parity'
    positions: []
    len: 1
    reverse: (x) -> x
    flip: (x) -> [x]
]

position_updates = []
n_indexes = 0

single_index_table = null

build_single_index_table = ->
  single_index_table = []
  single_i = 0
  for p in patterns
    p.single_index = {}
    for i in [0...(3**p.len+1)/2]
      if p.normalize(i) == Math.abs(i) or p.normalize(-i) == Math.abs(i)
        single_index_table.push {pattern:p.name, index:i}
        p.single_index[i] = single_i
        single_i++
      else
        p.single_index[i] = null

get_single_index = (i) ->
  if single_index_table == null
    build_single_index_table()
  single_index_table[i]

get_single_index_size = () ->
  if single_index_table == null
    build_single_index_table()
  single_index_table.length

init = ->
  index = 0
  for p in patterns
    p.flips = p.flip(p.positions)
    p.len = p.positions.length if not p.len
    next_index = index + p.flips.length
    p.indexes = [index...next_index]
    index = next_index
  n_indexes = next_index

  for p in patterns
    for i in [0...p.flips.length]
      positions = p.flips[i]
      idx = p.indexes[i]
      u = 1
      for [x, y] in positions
        pos = pos_from_xy(x, y)
        position_updates[pos] ||= []
        position_updates[pos].push [idx, u]
        u *= 3

  patterns.forEach (p) ->
    map = p.normalize_map
    unless map
      map = p.normalize_map = normalize_map p.reverse, p.len
    p.normalize = (index) -> map.get(index)

  for p in patterns
    patterns[p.name] = p

  patterns.forEach (p) ->
    p.get_single_index = (i) ->
      if single_index_table == null
        build_single_index_table()
      p.single_index[i]

init()

parity_index = patterns.parity.indexes[0]

class PatternBoard extends Board
  constructor: (x) ->
    super x
    @init_indexes()

  load: (s) ->
    super s
    @init_indexes()

  init_indexes: ->
    @n_discs = 0
    @indexes = (0 for i in [0...n_indexes])
    for pos in ALL_POSITIONS
      if @board[pos]
        for [i, u] in position_updates[pos]
          @indexes[i] += @board[pos] * u
        @n_discs++

  move: (me, pos) ->
    flips = super(me, pos)
    if flips.length
      for [i, u] in position_updates[pos]
        @indexes[i] += me * u
      me2 = 2 * me
      for pos in flips
        for [i, u] in position_updates[pos]
          @indexes[i] += me2 * u
      @n_discs++

    flips

  undo: (me, pos, flips) ->
    super(me, pos, flips)
    if flips.length
      for [i, u] in position_updates[pos]
        @indexes[i] -= me * u
      me2 = 2 * me
      for pos in flips
        for [i, u] in position_updates[pos]
          @indexes[i] -= me2 * u
      @n_discs--

  set_parity: (me) ->
    parity = @n_discs & 1
    @indexes[parity_index] = if parity then me else -me

  dump_indexes: ->
    for p in patterns
      process.stdout.write "#{p.name}:"
      for i in p.indexes
        process.stdout.write " #{@indexes[i]}"
      process.stdout.write '\n'

    saved = @indexes
    @indexes = []
    @init_indexes()
    for i in [0...@indexes.length]
      if i != parity_index
        console.assert @indexes[i] == saved[i]
    console.log 'ok'
    @indexes = saved

module.exports = { PatternBoard, N_PHASES, N_MOVES_PER_PHASE, patterns, n_indexes, get_single_index, get_single_index_size }

if 0
  for i in [0..all_one(10)]
    r = reverse_index(i, 10)
    rr = reverse_index(r, 10)
    console.assert i == rr

    r = reverse_index(-i, 10)
    rr = reverse_index(r, 10)
    console.assert -i == rr

  for i in [0..all_one(9)]
    r = reverse_index_xy(i, 9)
    rr = reverse_index_xy(r, 9)
    console.assert i == rr

    r = reverse_index_xy(-i, 9)
    rr = reverse_index_xy(r, 9)
    console.assert -i == rr

  console.log 'ok'

if 0
  { pos_to_str } = require './board'
  for p in patterns
    console.log p.name
    for positions in p.flips
      for [x, y] in positions
        process.stdout.write pos_to_str pos_from_xy(x, y)
      process.stdout.write '\n'
    console.log 'indexes:', p.indexes
  for pos in ALL_POSITIONS
    console.log pos_to_str(pos), position_updates[pos]

if 0
  #console.log reverse_map reverse_index, 4
  b = new PatternBoard
  b.load '''
    X X X - - - - -
    O O X - - - - -
    X - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    '''
  i1 = b.indexes[0]
  b.load '''
    X O X - - - - -
    X O - - - - - -
    X X - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    '''
  b.set_parity BLACK
  b.dump_indexes()
  i2 = b.indexes[0]
  p = patterns[0]
  console.log i1, p.normalize(i1)
  console.log i2, p.normalize(i2)
  console.assert p.normalize(i1) == p.normalize(i2)

if 0
  console.log get_single_index_size()
  console.log JSON.stringify single_index_table
  for p in patterns
    console.log p.name, p.single_index
