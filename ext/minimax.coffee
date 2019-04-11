ext = require '.'
convert_weights = require './convert-weights'
{ pos_from_native_move } = require './util'

module.exports = (opt) ->
  weights = convert_weights(opt.weights)

  (board, turn) ->
    ext.set_verbose opt.verbose
    ext.set_weights weights, opt.inverted
    { move, value } = ext.minimax(board.dump(), turn, opt.max_depth, opt.max_nodes)

    { move: pos_from_native_move(move), value }
