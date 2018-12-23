{EMPTY, pos_from_str} = require './board'
Book = require './book'

defaults =
  db: 'old/book.db'
  min: 100
  random: 0.8
  verbose: true

F5 = pos_from_str('F5')

module.exports = (options={}) ->
  opts = {defaults..., options...}

  book = new Book opts.db

  (board, me, moves) ->
    nodes = []
    sum = 0
    max = -Infinity
    best = null
    for move in moves or board.list_moves(me)
      flips = board.move me, move
      data = await book.get(board)
      board.undo me, move, flips
      if data and data.n >= opts.min
        node = {move, n:data.n, value:data.value, solved:data.solved}
        nodes.push node
        if data.n > max
          max = data.n
          best = node
        sum += data.n
    return null unless nodes.length

    if opts.random
      sum_p = 0
      for node in nodes
        node.p = (node.n / sum) ** (1/opts.random)
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
