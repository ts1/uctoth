{ Board, EMPTY, pos_from_str, pos_to_xy, pos_from_xy } = require './board'

CACHE_SIZE = 200000
CACHE = true
CACHE_THRESHOLD = 8
ORDER_THRESHOLD = 9

cache = require('./cache')(CACHE_SIZE)

if CACHE
  cached_solve = (f, board) ->
    (me, lower, upper, score, pass, left) ->
      if left <= CACHE_THRESHOLD
        return f me, lower, upper, score, pass, left

      value = cache.get(board, me, left, lower, upper)
      if value != null
        return value

      value = f me, lower, upper, score, pass, left

      cache.set board, me, left, lower, upper, value
      value
else
  cached_solve = (f, board) -> f

simple_solve = (board, me, lower, upper, base_score, left) ->
  board = new Board board

  terminal_solve = (me, score) ->
    pos = board.first_empty()
    flips = board.move(me, pos, false)
    n = flips.length
    if n
      board.undo(me, pos, flips, false)
      score + 2*n + 1
    else
      flips = board.move(-me, pos)
      n = flips.length
      if n
        board.undo(-me, pos, flips, false)
        score - 2*n + 1
      else
        if score > 0
          score + 1
        else if score < 0
          score - 1
        else
          score

  solve = (me, lower, upper, base_score, pass, left) =>
    if left == 1
      return terminal_solve(me, base_score)

    any_moves = false
    board.each_empty (pos) =>
      flips = board.move(me, pos)
      n = flips.length
      return true unless n
      any_moves = true
      score = base_score + 2*n + 1
      score = -solve(-me, -upper, -lower, -score, 0, left-1)
      board.undo me, pos, flips
      if score > lower
        lower = score
        return false if score >= upper # stop iteration
      true # continue iteration
    if any_moves
      lower
    else
      if pass
        if base_score > 0
          base_score + left
        else if base_score < 0
          base_score - left
      else
        -solve(-me, -upper, -lower, -base_score, 1, left)

  solve = cached_solve solve, board
  solve(me, lower, upper, base_score, 0, left)

ordered_solve = (board, me, lower, upper, base_score, left, evaluator) ->
  solve = (me, lower, upper, base_score, pass, left) ->
    if left <= ORDER_THRESHOLD
      return simple_solve(board, me, lower, upper, base_score, left)

    moves = []
    board.each_empty (pos) ->
      flips = board.move me, pos
      if flips.length
        score = -evaluator(board, -me)
        board.undo me, pos, flips
        moves.push [pos, score]

    unless moves.length
      if pass
        if base_score > 0
          return base_score + left
        else if base_score < 0
          return base_score - left
      else
        return -solve(-me, -upper, -lower, -base_score, 1, left)

    moves.sort (a, b) -> b[1] - a[1]

    for [pos] in moves
      flips = board.move me, pos
      score = base_score + 2*flips.length + 1
      if upper - lower > 1 and left >= 12
        s = -solve(-me, -(lower+1), -lower, -score, 0, left-1)
        if s > lower and s < upper
          s = -solve(-me, -upper, -s, -score, 0, left-1)
        score = s
      else
        score = -solve(-me, -upper, -lower, -score, 0, left-1)
      board.undo me, pos, flips
      if score > lower
        lower = score
        if score >= upper
          break
    lower

  solve = cached_solve solve, board
  solve(me, lower, upper, base_score, 0, left)

module.exports = solve = (board, me, lower, upper, evaluator) ->
  score = board.score(me)
  left = board.count(EMPTY)
  if evaluator
    ordered_solve(board, me, lower, upper, score, left, evaluator)
  else
    simple_solve(board, me, lower, upper, score, left)

solve.cache_clear = ->
  cache = require('./cache')(CACHE_SIZE)

solve.cache_stats = ->
  cache.stats()
