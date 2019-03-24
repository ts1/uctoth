ext = require '.'
convert_weights = require './convert-weights'
{ pos_from_native_move } = require './util'

module.exports = (opt) ->
  weights = convert_weights(opt.weights)

  (board, turn) ->
    ext.set_verbose opt.verbose
    ext.set_weights weights
    { move, value } = ext.uct_search(board.dump(), turn, opt.n_search,
      opt.scope, opt.randomness, opt.tenacious)

    { move: pos_from_native_move(move), value }
