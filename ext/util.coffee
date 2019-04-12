{ pos_from_xy, pos_to_xy } = require '../board'
{ int } = require '../util'

exports.pos_from_native_move = (move) ->
  x = move % 8
  y = int(move / 8)
  pos_from_xy(7-x, 7-y)

exports.pos_to_native_move = (pos) ->
  { x, y } = pos_to_xy(pos)
  x = 7 - x
  y = 7 - y
  y * 8 + x
