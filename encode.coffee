{UP, DOWN, LEFT, RIGHT, pos_from_xy, Board, square_to_char} = require './board'
{int} = require './util'

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

encode_to_array = (board, dir=scan_dirs[0], min=[Infinity]) ->
  { start, major, minor } = dir
  array = []
  pos = start
  for i in [0..7]
    p = pos
    for j in [0..1]
      e = 0
      for k in [0..3]
        e = e*3 + (board.get(p) + 1)
        p += minor
      array.push e+0x23
    pos += major
    return min if array > min
  array

array_to_string = (array) -> String.fromCharCode(array...).replace('\\', '~')

encode = (board) -> array_to_string encode_to_array board

encode_normalized = (board) ->
  min = [Infinity]
  for dir in scan_dirs
    array = encode_to_array board, dir, min
    if array < min
      min = array
  array_to_string min

decode = (code) ->
  array = []

  sub = (e, len) ->
    if len
      sub(int(e / 3), len-1)
      array.push e % 3
    else
      array.push e

  code = code.replace('~', '\\')
  for i in [0..15]
    e = code.charCodeAt(i) - 0x23
    sub e, 3

  array.map((x) -> square_to_char(parseInt(x) - 1)).join('')

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
  console.log decode encode b
  console.assert (decode encode b) == (decode encode new Board decode encode b)

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
