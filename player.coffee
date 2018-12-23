{EMPTY, pos_from_str} = require './board'
solve = require './endgame'
{ encode_normalized } = require './encode'

defaults =
  book: null
  strategy: require('./minmax')()
  endgame_eval: null
  solve_wld: 18
  solve_full: 20
  verbose: true

F5 = pos_from_str('F5')

module.exports = (options={}) ->
  opts = {defaults..., options...}

  opts.endgame_eval or= require('./pattern_eval')('scores')

  (board, me, force_moves=null) ->
    left = board.count(EMPTY)
    if left == 60 and board.can_move(me, F5)
      return {move:F5}

    moves = force_moves or board.list_moves(me)
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
      return solve(board, me, false, opts.verbose, opts.endgame_eval, unique_moves)

    if left <= opts.solve_wld
      console.log 'win-loss-draw solve' if opts.verbose
      return solve(board, me, true, opts.verbose, opts.endgame_eval, unique_moves)

    if opts.book
      move = await opts.book(board, me, unique_moves)
      if move
        return move

    opts.strategy(board, me, unique_moves)
