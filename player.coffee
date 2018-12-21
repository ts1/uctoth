{EMPTY, pos_from_str} = require './board'
solve = require './endgame'
Book = require './book'
{ encode_normalized } = require './encode'

defaults =
  book: 'old/book.db'
  book_min: 100
  book_random: 0.8
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
    nodes = []
    sum = 0
    max = -Infinity
    best = null
    for move in moves
      flips = board.move me, move
      data = await book.get(board)
      board.undo me, move, flips
      if data and data.n >= opts.book_min
        node = {move, n:data.n, value:data.value, solved:data.solved}
        nodes.push node
        if data.n > max
          max = data.n
          best = node
        sum += data.n
    return null unless nodes.length

    if opts.book_random
      sum_p = 0
      for node in nodes
        node.p = (node.n / sum) ** (1/opts.book_random)
        sum_p += node.p

      r = Math.random() * sum_p
      sum_p = 0
      for node in nodes
        sum_p += node.p
        if sum_p > r
          best = node
          break

    console.log 'book', max if opts.verbose
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
