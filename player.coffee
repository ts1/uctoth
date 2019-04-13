{ EMPTY, pos_from_str } = require './board'
{ encode_normalized } = require './encode'
endgame = require './endgame'
{ shuffle } = require './util'
ext = require('./ext')

defaults =
  book: null
  strategy: null
  solve_wld: 24
  solve_full: 22
  verbose: true
  inverted: false
  endgame_eval: null
  endgame_weights: 'ref/weights.json'
  shuffle: false

F5 = pos_from_str('F5')

module.exports = (options={}) ->
  opts = {defaults..., options...}

  if ext.is_enabled and not opts.inverted
    ext_endgame = require './ext/endgame'
    solve = ext_endgame(weights: opts.endgame_weights, verbose: opts.verbose)
  else
    solve = if opts.inverted
      endgame
        verbose: opts.verbose
        evaluate: opts.endgame_eval or require('./pattern_eval')('weights.json', true)
        inverted: true
    else
      endgame
        verbose: opts.verbose
        evaluate: opts.endgame_eval or require('./pattern_eval')('weights.json')

  (board, me, force_moves=null) ->
    left = board.count(EMPTY)
    if not opts.shuffle and left == 60 and board.can_move(me, F5)
      return {move:F5}

    moves = force_moves or board.list_moves(me)
    moves = shuffle moves if opts.shuffle
    codes = {}
    unique_moves = []
    for move in moves
      flips = board.move me, move
      code = encode_normalized(board)
      board.undo me, move, flips
      unless codes[code]
        codes[code] = true
        unique_moves.push move

    if unique_moves.length == 1 and not force_moves
      return {move:unique_moves[0]}

    if left <= opts.solve_full
      console.log 'full solve' if opts.verbose
      return solve(board, me, false, unique_moves)

    if left <= opts.solve_wld
      console.log 'win-loss-draw solve' if opts.verbose
      return solve(board, me, true, unique_moves)

    if opts.book
      move = opts.book(board, me, unique_moves)
      if move
        return move

    opts.strategy(board, me, unique_moves)

module.exports.defaults = defaults
