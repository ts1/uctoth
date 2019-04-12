ext = require '.'
convert_weights = require './convert-weights'
{ pos_from_native_move, pos_to_native_move } = require './util'

module.exports = (opt) ->
  weights = convert_weights(opt.weights)

  (board, turn, moves=null) ->
    ext.set_verbose opt.verbose
    ext.set_weights weights, opt.inverted

    if moves? and moves.length != board.list_moves(turn).length
      mask_lower = mask_upper = 0
      for pos in moves
        move = pos_to_native_move(pos)
        if move < 32
          mask_lower |= 1 << move
        else
          mask_upper |= 1 << (move - 32)

    { move, value } = ext.minimax(board.dump(), turn, opt.max_depth,
      opt.max_nodes, mask_lower, mask_upper)

    move = pos_from_native_move(move)
    { move, value }
