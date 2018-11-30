{EMPTY, pos_from_str} = require './board'
solve = require './endgame'
Book = require './book'
{ encode_normalized } = require './encode'

defaults =
  book: 'book.db'
  book_min: 10
  searcher: require('./minmax')()
  solve_wld: 18
  solve_full: 20
  verbose: true

F5 = pos_from_str('F5')

module.exports = (options={}) ->
  opts = {defaults..., options...}

  if opts.book
    book = new Book opts.book

  book_move = (board, me, moves) ->
    max = opts.book_min
    best = null
    for move in moves
      flips = board.move me, move
      data = await book.get(board)
      board.undo me, move, flips
      if data and data.n >= max
        max = data.n
        best = {move, value:data.value*me, solved:data.solved}
    return null unless best
    console.log 'book', max if opts.verbose
    best

  (board, me, moves=null) ->
    left = board.count(EMPTY)
    if left == 60 and board.can_move(me, F5)
      return {move:F5}

    moves or= board.list_moves(me)
    codes = {}
    unique_moves = []
    for move in moves
      flips = board.move me, move
      code = encode_normalized(board)
      board.undo me, move, flips
      unless codes[code]
        codes[code] = true
        unique_moves.push move

    if unique_moves.length == 1
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

    opts.searcher(board, me, unique_moves)