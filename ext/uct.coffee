ext = require '.'
convert_weights = require './convert-weights'
{ pos_from_native_move, moves_to_mask } = require './util'

module.exports = (opt) ->
  weights = convert_weights(opt.weights)

  (board, turn, moves=null) ->
    ext.set_verbose opt.verbose
    ext.set_weights weights, opt.inverted

    ext.set_uct_options(
      opt.n_search
      opt.scope
      opt.randomness
      opt.tenacious
      opt.by_value
    )

    { mask_lower, mask_upper } = moves_to_mask(moves)
    { move, value } = ext.uct_search(board.dump(), turn, mask_lower, mask_upper)

    { move: pos_from_native_move(move), value }
