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

exports.moves_to_mask = (moves) ->
  mask_lower = mask_upper = 0
  if moves?
    for pos in moves
      move = exports.pos_to_native_move(pos)
      if move < 32
        mask_lower |= 1 << move
      else
        mask_upper |= 1 << (move - 32)
  { mask_lower, mask_upper }
