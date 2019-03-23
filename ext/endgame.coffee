path = require 'path'
ext = require '.'
convert_weights = require './convert-weights'
{ pos_from_native_move } = require './util'

defaults =
  weights: path.resolve __dirname, '..', 'ref', 'weights.json'
  verbose: true

module.exports = (options) ->
  opt = { defaults..., options... }

  weights = convert_weights(opt.weights)

  (board, turn, wld) ->
    ext.set_verbose opt.verbose
    ext.set_weights weights
    { move, value } = ext.solve(board.dump(), turn, wld)

    {
      move: pos_from_native_move(move)
      value
      solved: if wld then 'wld' else 'full'
    }
