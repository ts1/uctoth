{ UP, DOWN, LEFT, RIGHT, pos_from_xy, Board, square_to_char } = require './board'

scan_dirs = [
    start: pos_from_xy(0, 0)
    major: DOWN
    minor: RIGHT
  ,
    start: pos_from_xy(7, 0)
    major: DOWN
    minor: LEFT
  ,
    start: pos_from_xy(0, 7)
    major: UP
    minor: RIGHT
  ,
    start: pos_from_xy(7, 7)
    major: UP
    minor: LEFT
  ,
    start: pos_from_xy(0, 0)
    major: RIGHT
    minor: DOWN
  ,
    start: pos_from_xy(0, 7)
    major: RIGHT
    minor: UP
  ,
    start: pos_from_xy(7, 0)
    major: LEFT
    minor: DOWN
  ,
    start: pos_from_xy(7, 7)
    major: LEFT
    minor: UP
]

encode_to_array = (board, dir=scan_dirs[0], upper) ->
  array = []
  { start, major, minor } = dir
  pos = start
  for i in [0..7]
    p = pos
    bits = 0
    for j in [0..7]
      array.push(board.get(p) + 1)
      p += minor
    pos += major
    if array > upper
      break
  array

encode = (board, dir=scan_dirs[0]) -> encode_to_array(board, dir).join('')

encode_normalized = (board) ->
  min = [999]
  for dir in scan_dirs
    code = encode_to_array board, dir, min
    if code < min
      min = code
  min.join('')

decode = (code) ->
  code.split('').map((x) -> square_to_char(parseInt(x) - 1)).join('')

module.exports = { encode, encode_normalized, decode }

if 0
  { Board } = require './board'
  b = new Board
  b.load '''
    X X X - - - - -
    X O - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    '''
  console.log encode b
  code1 = encode_normalized b

  b = new Board
  b.load '''
    - - - - - X X X
    - - - - - - O X
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    '''
  console.log encode b
  code2 = encode_normalized b

  console.log code1
  console.assert code1 == code2
  console.log 'ok'
