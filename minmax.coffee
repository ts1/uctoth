{ EMPTY, pos_from_str, pos_to_str, Board } = require './board'
{ PatternBoard } = require './pattern'
solve = require './endgame'

corner_zone = do ->
  b = new Board
  b.load '''
    - X - - - - X -
    X X - - - - X X
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    - - - - - - - -
    X X - - - - X X
    - X - - - - X -
    '''
  b

defaults =
  evaluate: require './simple_eval'
  max_depth: 6
  verbose: true
  invert: false
  cq: false
  board_class: PatternBoard
  cache_size: 300000
  zws: true
  shuffle: true

module.exports = (options={}) ->
  {
    evaluate
    max_depth
    verbose
    invert
    cq
    board_class
    cache_size
    zws
    shuffle
  } = {defaults..., options...}

  if invert
    orig_evaluate = evaluate
    evaluate = (board, me) -> -orig_evaluate(board, me)

  simple_minmax = (board, me, lower, upper, pass, depth) ->
    if depth <= 0
      return evaluate(board, me)

    any_moves = false
    board.each_empty (pos) ->
      flips = board.move(me, pos)
      if flips.length
        any_moves = true
        next_depth = depth - 1
        if cq and next_depth == 0 and corner_zone.get(pos)
          next_depth = 1
        score = -simple_minmax(board, -me, -upper, -lower, 0, next_depth)
        board.undo(me, pos, flips)
        if score > lower
          lower = score
          if score >= upper
            return false # stop iteration
    if any_moves
      lower
    else
      if pass
        evaluate(board, me)
      else
        -simple_minmax(board, -me, -upper, -lower, 1, depth-1)

  minmax = (board, me, lower, upper, pass, depth) ->
    if depth <= 4
      return simple_minmax(board, me, lower, upper, pass, depth)

    moves = []

    any_moves = false
    board.each_empty (pos) ->
      flips = board.move(me, pos)
      if flips.length
        any_moves = true
        score = -simple_minmax(board, -me, -Infinity, Infinity, 0, 1)
        board.undo(me, pos, flips)
        moves.push [pos, score]

    unless any_moves
      if pass
        return evaluate(board, me)
      else
        return -minmax(board, -me, -upper, -lower, 1, depth-1)

    moves.sort (a, b) -> (b[1] - a[1])

    for [pos] in moves
      flips = board.move(me, pos)
      next_depth = depth - 1
      if cq and next_depth == 0 and corner_zone.get(pos)
        next_depth = 1
      if zws and depth >= 4 and isFinite(lower) and upper - lower > 0.0015
        score = -minmax(board, -me, -(lower+0.001), -lower, 0, next_depth)
        if score > lower and score < upper
          score = -minmax(board, -me, -upper, -score, 0, next_depth)
      else
        score = -minmax(board, -me, -upper, -lower, 0, next_depth)
      board.undo(me, pos, flips)
      if score > lower
        lower = score
        if score >= upper
          break
    lower

  if cache_size
    cache = require('./cache')(cache_size)

    cache_depth = max_depth - 6
    if cache_depth < 1
      cache_depth = 1

    cached_minmax = (f) ->
      (board, me, lower, upper, pass, depth) ->
        if depth < cache_depth
          return f board, me, lower, upper, pass, depth

        value = cache.get(board, me, depth, lower, upper)
        if value != null
          return value

        value = f board, me, lower, upper, pass, depth

        cache.set board, me, depth, lower, upper, value
        value

    simple_minmax = cached_minmax simple_minmax
    minmax = cached_minmax minmax

  main = (board, me, moves=null) ->
    #if cache_size
    #  cache = require('./cache')(cache_size)

    board = new board_class board

    moves or= board.list_moves(me)
    move_scores = {}
    if shuffle
      moves.forEach (pos) -> move_scores[pos] = Math.random()
    else
      moves.forEach (pos) -> move_scores[pos] = 0

    left = board.count(EMPTY)

    for depth in [1..max_depth]
      if depth > left
        break
      console.log "depth: #{depth}" if verbose
      moves.sort (a, b) -> move_scores[b] - move_scores[a]
      max = -Infinity
      best = 0
      for pos in moves
        flips = board.move(me, pos)
        if flips.length
          process.stdout.write "#{pos_to_str(pos)}:" if verbose
          if zws and isFinite(max)
            score = -minmax(board, -me, -(max+0.001), -max, 0, depth-1)
            if score > max
              process.stdout.write('!') if verbose
              score = -minmax(board, -me, -Infinity, -score, 0, depth-1)
          else
            score = -minmax(board, -me, -Infinity, -max, 0, depth-1)
          board.undo(me, pos, flips)
          if score > max
            process.stdout.write "#{score} " if verbose
            max = score
            best = pos
          else
            if depth > 1
              process.stdout.write '* ' if verbose
              score = -99
            else
              process.stdout.write "#{score} " if verbose
          move_scores[pos] *= .001
          move_scores[pos] += score
      process.stdout.write '\n' if verbose

    #if verbose and cache_size
    #  cache.stats()

    {value: max, move: best, solved: null}

  main.minmax = minmax
  main.simple_minmax = simple_minmax

  main
