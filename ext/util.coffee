{ pos_from_xy } = require '../board'
{ int } = require '../util'

exports.pos_from_native_move = (move) ->
  x = move % 8
  y = int(move / 8)
  pos_from_xy(7-x, 7-y)
