{ encode_normalized } = require './encode'
book = require './openings.json'
{ SCORE_MULT } = require './pattern'

defaults =
  random: 0.7
  verbose: true

module.exports = (options={}) ->
  opts = {defaults..., options...}

  (board, me, moves) ->
    nodes = []
    sum = 0
    max = -Infinity
    best = null
    for move in moves or board.list_moves(me)
      flips = board.move me, move
      code = encode_normalized(board)
      data = book[code]
      board.undo me, move, flips
      if data
        value = data.value * me
        node = {move, value, n:data.n}
        nodes.push node
        if value > max
          max = value
          best = node
    return null unless nodes.length

    if opts.random
      sum_p = 0
      for node in nodes
        node.p = Math.exp(node.value / (1*SCORE_MULT*opts.random))
        sum_p += node.p

      r = Math.random() * sum_p
      sum_p = 0
      for node in nodes
        sum_p += node.p
        if sum_p > r
          best = node
          break

    console.log 'book', best.n if opts.verbose
    best
