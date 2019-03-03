require './rejection_handler'
Book = require './book'
{ SCORE_MULT } = require './pattern'

defaults =
  book: 'book.db'
  random: 0.7
  verbose: true

module.exports = (options={}) ->
  opt = {defaults..., options...}

  book = new Book opt.book, readonly: true

  (board, me, moves) ->
    nodes = []
    sum = 0
    max = -Infinity
    best = null
    for move in moves or board.list_moves(me)
      flips = board.move me, move
      data = book.get_op_node(board)
      board.undo me, move, flips
      if data
        value = data.pub_value * me
        node = {move, value, n:data.n_visited}
        nodes.push node
        if value > max
          max = value
          best = node
    return null unless nodes.length

    if opt.random
      sum_p = 0
      for node in nodes
        node.p = Math.exp(node.value / (1*SCORE_MULT*opt.random))
        sum_p += node.p

      r = Math.random() * sum_p
      sum_p = 0
      for node in nodes
        sum_p += node.p
        if sum_p > r
          best = node
          break

    console.log 'book', best.n if opt.verbose
    best
