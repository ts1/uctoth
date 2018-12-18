{EMPTY, pos_from_str} = require './board'
solve = require './endgame'
Book = require './book'
{ encode_normalized } = require './encode'

defaults =
  book: 'old/book.db'
  book_min: 100
  strategy: require('./minmax')()
  solve_wld: 18
  solve_full: 20
  verbose: true

F5 = pos_from_str('F5')

module.exports = (options={}) ->
  opts = {defaults..., options...}

  if opts.book
    book = new Book opts.book

  book_move = (board, me, moves) ->
    max = -Infinity
    best = null
    max_n = 0
    for move in moves
      flips = board.move me, move
      data = await book.get(board)
      board.undo me, move, flips
      if data and data.value*me >= max
        max = data.value*me
        best = {move, value:data.value*me, solved:data.solved}
        max_n = data.n
    return null if max_n < opts.book_min
    return null unless best
    console.log 'book', max_n if opts.verbose
    best

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
      return solve(board, me, false, opts.verbose, unique_moves)

    if left <= opts.solve_wld
      console.log 'win-loss-draw solve' if opts.verbose
      return solve(board, me, true, opts.verbose, unique_moves)

    if opts.book
      move = await book_move(board, me, unique_moves)
      if move
        return move

    opts.strategy(board, me, unique_moves)
