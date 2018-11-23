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

pos_to_str = (pos) ->
  { x, y } = pos_to_xy(pos)
  String.fromCharCode('A'.charCodeAt(0) + x) + (y + 1)

pos_array_from_str = (s) ->
  re = /([a-hA-H][1-8])/g
  while true
    m = re.exec s
    if m
      pos_from_str m[0]
    else
      break

pos_array_to_str = (array) -> array.map(pos_to_str).join('')

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

ALL_BUT_X = do ->
  result = []
  for y in [0..7]
    for x in [0..7]
      if (x==1 or x==6) and (y==1 or y==6)
        continue
      result.push pos_from_xy x, y
  result

UP = -9
DOWN = +9
LEFT = -1
RIGHT = +1

ALL_DIRECTIONS = [
  UP+LEFT, UP, UP+RIGHT,
  LEFT, RIGHT,
  DOWN+LEFT, DOWN, DOWN+RIGHT
]

class Board
  constructor: (s) ->
    if s
      if typeof s == 'string'
        @load s
      else
        @board = [s.board...]
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
      for d in ALL_DIRECTIONS
        p = pos + d
        if @board[p] == foe
          p += d
          while @board[p] == foe
            p += d
          if @board[p] == me
            return true
    false

  any_moves: (me) -> ALL_POSITIONS.some (pos) => @can_move(me, pos)

  list_moves: (me) -> ALL_POSITIONS.filter (pos) => @can_move(me, pos)

  list_moves_but_x: (me) -> ALL_BUT_X.filter (pos) => @can_move(me, pos)

  move: (me, pos) ->
    flips = []
    if @board[pos] == EMPTY
      foe = -me
      for d in ALL_DIRECTIONS
        p = pos + d
        if @board[p] == foe
          p += d
          while @board[p] == foe
            p += d
          if @board[p] == me
            while (p -= d) != pos
              @board[p] = me
              flips.push p
      @board[pos] = me if flips.length
    flips

  undo: (me, pos, flips) ->
    foe = -me
    for p in flips
      @board[p] = foe
    @board[pos] = EMPTY

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

module.exports = {
  EMPTY, BLACK, WHITE, GUARD,
  ALL_POSITIONS,
  UP, DOWN, LEFT, RIGHT,
  pos_from_xy, pos_from_str, pos_to_xy, pos_to_str,
  pos_array_from_str, pos_array_to_str,
  square_to_char, char_to_square,
  Board,
}
