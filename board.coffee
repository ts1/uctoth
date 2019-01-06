{ int } = require './util'

EMPTY = 0
BLACK = 1
WHITE = -1
GUARD = 2

pos_from_xy = (x, y) -> (y + 1) * 9 + (x + 1)

pos_from_str = (s) ->
  x = s.toLowerCase().charCodeAt(0) - 'a'.charCodeAt(0)
  y = parseInt(s[1]) - 1
  if x < 0 or x > 7 or y < 0 or y > 7
    throw new Error 'invalid position string'
  pos_from_xy(x, y)

pos_to_xy = (pos) ->
  x: pos % 9 - 1
  y: int(pos / 9) - 1

pos_to_str = (pos, me=BLACK) ->
  { x, y } = pos_to_xy(pos)
  char = if me==BLACK then 'A' else 'a'
  String.fromCharCode(char.charCodeAt(0) + x) + (y + 1)

pos_array_from_str = (s) ->
  re = /([a-hA-H][1-8])/g
  while true
    m = re.exec s
    if m
      pos_from_str m[0]
    else
      break

pos_array_to_str = (array) ->
  result = for item in array
    if item.move? and item.turn?
      pos_to_str(item.move, item.turn)
    else
      pos_to_str(item)
  result.join('')

_char_to_square = { '-': EMPTY, 'X': BLACK, 'O': WHITE }

char_to_square = (ch) -> _char_to_square[ch]

square_to_char = do ->
  map = new Map([sq, ch] for ch, sq of _char_to_square)
  (sq) -> map.get(sq) or '?'

ALL_POSITIONS = do ->
  result = []
  for y in [0..7]
    for x in [0..7]
      result.push pos_from_xy x, y
  result

X_LIST = []
X_LIST[pos_from_str('B2')] = true
X_LIST[pos_from_str('G2')] = true
X_LIST[pos_from_str('B7')] = true
X_LIST[pos_from_str('G7')] = true

UP = -9
DOWN = +9
LEFT = -1
RIGHT = +1

FLIP_DIR_TBL = do ->
  tbl = []
  for y in [0..7]
    for x in [0..7]
      tbl[pos_from_xy x, y] = dirs = []
      if x > 1
        dirs.push LEFT
        if y > 1
          dirs.push LEFT+UP
        if y < 6
          dirs.push LEFT+DOWN
      if x < 6
        dirs.push RIGHT
        if y > 1
          dirs.push RIGHT+UP
        if y < 6
          dirs.push RIGHT+DOWN
      if y > 1
        dirs.push UP
      if y < 6
        dirs.push DOWN
  tbl

SEARCH_ORDER = do ->
  # Search order of moves in upper left quarter of board,
  # possibly strongest first.
  QUARTER_ORDER = [
    'A1', # corner
    'C1', 'A3',
    'D1', 'A4',
    'C3',
    'D3', 'C4',
    'D2', 'B4',
    'B1', 'A2',
    'C2', 'B3',
    'B2' # X
    'D4' # just in case
  ]
  order = []
  for spos in QUARTER_ORDER
    pos = pos_from_str(spos)
    {x, y} = pos_to_xy(pos)
    order.push pos_from_xy(x, y)
    order.push pos_from_xy(7-x, y)
    order.push pos_from_xy(x, 7-y)
    order.push pos_from_xy(7-x, 7-y)
  order

class Board
  constructor: (s) ->
    if s
      if typeof s == 'string'
        @load s
      else
        @board = [s.board...]
        @build_empty_list()
    else
      @load '''
        - - - - - - - -
        - - - - - - - -
        - - - - - - - -
        - - - O X - - -
        - - - X O - - -
        - - - - - - - -
        - - - - - - - -
        - - - - - - - -
        '''

  load: (s) ->
    G = GUARD
    e = EMPTY
    @board = [
      G,G,G,G,G,G,G,G,G,
      G,e,e,e,e,e,e,e,e,
      G,e,e,e,e,e,e,e,e,
      G,e,e,e,e,e,e,e,e,
      G,e,e,e,e,e,e,e,e,
      G,e,e,e,e,e,e,e,e,
      G,e,e,e,e,e,e,e,e,
      G,e,e,e,e,e,e,e,e,
      G,e,e,e,e,e,e,e,e,
      G,G,G,G,G,G,G,G,G,G
    ]
    x = 0
    y = 0
    for c in s.split('')
      square = char_to_square(c)
      if typeof square != 'undefined'
        if y >= 8
          throw new Error 'too many cells'
        @board[pos_from_xy(x, y)] = square
        if ++x >= 8
          x = 0
          y++
    if y < 8
      throw new Error 'too few cells'
    @build_empty_list()

  dump: (pretty=false) ->
    l = []
    if pretty
      l.push ' '
      for x in [0..7]
        l.push ' '
        l.push String.fromCharCode('A'.charCodeAt(0) + x)
      l.push '\n'
    for y in [0..7]
      if pretty
        l.push y+1
        l.push ' '
      for x in [0..7]
        l.push(square_to_char(@board[pos_from_xy(x, y)]) or '?')
        l.push ' ' if pretty
      if pretty
        l.push y+1
      l.push '\n' if pretty
    if pretty
      l.push ' '
      for x in [0..7]
        l.push ' '
        l.push String.fromCharCode('A'.charCodeAt(0) + x)
    l.join ''

  get: (pos) -> @board[pos]

  count: (me) ->
    count = 0
    ALL_POSITIONS.forEach (pos) =>
      count++ if @board[pos] == me
    count

  can_move: (me, pos) ->
    if @board[pos] == EMPTY
      foe = -me
      for d in FLIP_DIR_TBL[pos]
        p = pos + d
        if @board[p] == foe
          p += d
          while @board[p] == foe
            p += d
          if @board[p] == me
            return true
    false

  any_moves: (me) ->
    result = false
    @each_empty (pos) =>
      if @can_move(me, pos)
        result = true
        return false # stop iteration
    result

  count_moves: (me) ->
    result = 0
    @each_empty (pos) =>
      result++ if @can_move(me, pos)
    result

  list_moves: (me) ->
    moves = []
    @each_empty (pos) =>
      if @can_move(me, pos)
        moves.push pos
    moves

  list_moves_but_x: (me) ->
    moves = []
    @each_empty (pos) =>
      unless X_LIST[pos]
        if @can_move(me, pos)
          moves.push pos
    moves

  move: (me, pos, update_empty=true) ->
    flips = []
    if @board[pos] == EMPTY
      foe = -me
      for d in FLIP_DIR_TBL[pos]
        p = pos + d
        if @board[p] == foe
          p += d
          while @board[p] == foe
            p += d
          if @board[p] == me
            while (p -= d) != pos
              @board[p] = me
              flips.push p
      if flips.length
        @board[pos] = me
        if update_empty
          @pop_empty_list pos
    flips

  count_flips: (me, pos) ->
    flips = 0
    if @board[pos] == EMPTY
      foe = -me
      for d in FLIP_DIR_TBL[pos]
        p = pos + d
        n = 0
        while @board[p] == foe
          p += d
          n++
        if @board[p] == me
          flips += n
    flips

  undo: (me, pos, flips, update_empty=true) ->
    foe = -me
    for p in flips
      @board[p] = foe
    @board[pos] = EMPTY
    if update_empty
      @push_empty_list pos

  score: (me) ->
    foe = -me
    score = 0
    ALL_POSITIONS.forEach (pos) =>
      switch @board[pos]
        when me then score++
        when foe then score--
    score

  outcome: (me=BLACK) ->
    foe = -me
    score = 0
    empty = 0
    ALL_POSITIONS.forEach (pos) =>
      switch @board[pos]
        when me then score++
        when foe then score--
        when EMPTY then empty++
    if empty
      if score > 0
        score += empty
      else if score < 0
        score -= empty
    score

  build_empty_list: ->
    @empty_next = [0]
    @empty_prev = [0]
    prev = 0
    ALL_POSITIONS.forEach (pos) =>
      if @board[pos] == EMPTY
        @empty_next[prev] = pos
        @empty_prev[pos] = prev
        prev = pos
    @empty_next[prev] = 0
    #@validate_empty_list()

  pop_empty_list: (pos) ->
    @empty_next[@empty_prev[pos]] = @empty_next[pos]
    @empty_prev[@empty_next[pos]] = @empty_prev[pos]
    #@validate_empty_list()

  push_empty_list: (pos) ->
    @empty_next[@empty_prev[pos]] = pos
    @empty_prev[@empty_next[pos]] = pos
    #@validate_empty_list()

  first_empty: -> @empty_next[0]

  each_empty: (cb) ->
    pos = 0
    loop
      pos = @empty_next[pos]
      if pos == 0
        break
      if cb(pos) == false
        break

  validate_empty_list: ->
    n = 0
    @each_empty (pos) =>
      console.assert @board[pos] == EMPTY
      n++
    m = 0
    ALL_POSITIONS.forEach (pos) =>
      if @board[pos] == EMPTY
        m++
    console.assert n == m


module.exports = {
  EMPTY, BLACK, WHITE, GUARD,
  ALL_POSITIONS,
  UP, DOWN, LEFT, RIGHT,
  pos_from_xy, pos_from_str, pos_to_xy, pos_to_str,
  pos_array_from_str, pos_array_to_str,
  square_to_char, char_to_square,
  Board,
}
