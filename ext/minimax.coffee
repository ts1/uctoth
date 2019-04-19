ext = require '.'
convert_weights = require './convert-weights'
{ pos_from_native_move, moves_to_mask } = require './util'

module.exports = (opt) ->
  weights = convert_weights(opt.weights)
  cache = ext.minimax_create_cache()

  (board, turn, moves=null) ->
    ext.set_verbose opt.verbose
    ext.set_weights weights, opt.inverted
    ext.minimax_set_cache cache

    { mask_lower, mask_upper } = moves_to_mask(moves)

    { move, value } = ext.minimax(board.dump(), turn, opt.max_depth,
      opt.max_nodes, mask_lower, mask_upper)

    move = pos_from_native_move(move)
    { move, value }
