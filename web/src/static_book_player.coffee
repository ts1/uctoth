{ encode_normalized } = require '@oth/encode'
defaults =
  book: null
  random: 0.8
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
      data = opts.book[code]
      board.undo me, move, flips
      if data
        node = {move, n:data.n, value:data.value}
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
