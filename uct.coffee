{ PatternBoard } = require './pattern'
{ pos_to_str } = require './board'

defaults =
  C: 1.9
  max_search: 14000
  verbose: true
  evaluate: null
  board_class: PatternBoard

module.exports = (options={}) ->
  options = {defaults..., options...}

  (board, me) ->
    board = new options.board_class board
    n_nodes = 0
    max_depth = 0
    n_eval = 0
    n_outcome = 0

    uct_search = (node, me, pass, depth) ->
      node.n++
      if not node.children or node.children.length == 0
        node.children = []
        max = -Infinity
        any_moves = false
        board.each_empty (move) ->
          flips = board.move me, move, false
          if flips.length
            any_moves = true
            value = -options.evaluate(board, -me)
            board.undo me, move, flips, false
            node.children.push {move, value, n:1}
            n_nodes++
            n_eval++
            #console.log pos_to_str(move), value
            if value > max
              max = value
        if any_moves
          if depth > max_depth
            max_depth = depth
          #console.log 'best', max
          #process.stdout.write " #{max}\n" if options.verbose
          return max
        else
          if pass
            #process.stdout.write " #{board.outcome()}\n" if options.verbose
            n_outcome++
            return board.outcome(me)
          else
            return -uct_search node, -me, true, depth
      else
        max = -Infinity
        best = null
        for child in node.children
          bias = options.C * Math.sqrt(node.n / child.n)
          value = child.value + bias
          #console.log pos_to_str(child.move), child.n, child.value, bias
          if value > max
            max = value
            best = child
        #console.log 'best', pos_to_str(best.move)

        flips = board.move me, best.move
        #process.stdout.write "#{pos_to_str(best.move)}" if options.verbose
        best.value = -uct_search best, -me, false, depth+1
        board.undo me, best.move, flips
        max = -Infinity
        for child in node.children
          #console.log 'return', pos_to_str(child.move), child.value
          if child.value > max
            max = child.value
        #console.log 'best', max
        return max

    root = {value:0, n:0, children:[]}
    while root.n < options.max_search
      uct_search root, me, false, 0
      if n_eval == n_outcome
        break

    node = root
    while node.children?.length
      max = -Infinity
      best = null
      for child in node.children
        if child.n > max
          max = child.n
          best = child
      process.stdout.write pos_to_str(best.move) if options.verbose
      node = best
    process.stdout.write " #{max_depth}\n" if options.verbose

    unless root.children.length
      return {moves:[]}

    max = -Infinity
    best = null
    for child in root.children
      if child.n > max
        max = child.n
        best = child
  
    moves = for child in root.children
      {move, n, value} = child
      {move, n, value}

    return {move:best.move, value:best.value, moves}
