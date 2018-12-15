{ PatternBoard } = require './pattern'
{ pos_to_str } = require './board'

defaults =
  C: 1.9
  max_search: 14000
  verbose: true
  evaluate: null
  board_class: PatternBoard
  random: 0

module.exports = (options={}) ->
  options = {defaults..., options...}

  (board, me) ->
    board = new options.board_class board
    max_depth = 0
    grew = false

    uct_search = (node, me, pass, depth) ->
      node.n++

      if node.pass?
        return -uct_search node.pass, -me, true, depth

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
            #console.log pos_to_str(move), value
            if value > max
              max = value
        if any_moves
          grew = true
          if depth > max_depth
            max_depth = depth
          #console.log 'best', max
          #process.stdout.write " #{max}\n" if options.verbose
          return max
        else
          if pass
            #process.stdout.write " #{board.outcome()}\n" if options.verbose
            unless node.outcome?
              node.outcome =  board.outcome(me)
              grew = true
            return node.outcome
          else
            node.pass = {n:1}
            return -uct_search node.pass, -me, true, depth
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
        ###
        unless flips.length
          console.trace 'invalid move'
          console.log board.dump true
          console.log pos_to_str(best.move)
          console.log me
          console.dir 'node', node
          console.dir 'best', best
          process.exit 1
        ###
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
      grew = false
      uct_search root, me, false, 0
      break unless grew

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
    process.stdout.write " #{max_depth+1}\n" if options.verbose

    unless root.children.length
      return {moves:[]}

    if options.random == 0
      max_n = -Infinity
      max_value = -Infinity
      best = null
      for child in root.children
        if child.n > max_n or (child.n == max_n and child.value > max_value)
          max_n = child.n
          max_value = child.value
          best = child
    else
      sum = 0
      for child in root.children
        sum += child.n
      t = 1 / options.random
      sum_p = 0
      for child in root.children
        child.p = (child.n / sum) ** t
        sum_p += child.p
      r = Math.random() * sum_p
      sum_p = 0
      for child in root.children
        sum_p += child.p
        if sum_p >= r
          best = child
          break
  
    moves = for child in root.children
      {move, n, value} = child
      {move, n, value}

    return {move:best.move, value:best.value, moves}
