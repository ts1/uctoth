ext = require '.'
convert_weights = require './convert-weights'
{ pos_from_native_move } = require './util'

module.exports = (opt) ->
  weights = convert_weights(opt.weights)

  (board, turn, moves=null) ->
    ext.set_verbose opt.verbose
    ext.set_weights weights, opt.inverted
    if moves? and moves.length != board.list_moves(turn).length
      max = -Infinity
      best = 0
      for move in moves
        flips = board.move(turn, move)
        throw new Error unless flips.length
        if board.any_moves(-turn)
          { value } = ext.minimax(board.dump(), -turn, opt.max_depth - 1,
            opt.max_nodes, -max, Infinity)
          value = -value
        else
          { value } = ext.minimax(board.dump(), turn, opt.max_depth - 1,
            opt.max_nodes, -Infinity, max)
        board.undo(turn, move, flips)
        if value > max
          max = value
          best = move
      move = best
      value = max
    else
      { move, value } = ext.minimax(board.dump(), turn, opt.max_depth,
        opt.max_nodes)
      move = pos_from_native_move(move)

    { move, value }
