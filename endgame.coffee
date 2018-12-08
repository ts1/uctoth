{ Board, EMPTY, pos_from_str, pos_to_xy, pos_from_xy, pos_to_str } = require './board'
uct = require './uct'

CACHE_SIZE = 300000
CACHE = true
CACHE_THRESHOLD = 8
ORDER_THRESHOLD = 9
SHALLOW_SEARCH = 5

if CACHE
  cache = require('./cache')(CACHE_SIZE)
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

  final_move = (me, score) ->
    pos = board.first_empty()
    n = board.count_flips(me, pos)
    if n
      score + 2*n + 1
    else
      n = board.count_flips(-me, pos)
      if n
        score - 2*n - 1
      else
        if score > 0
          score + 1
        else if score < 0
          score - 1
        else
          score

  solve_sub = (me, lower, upper, base_score, pass, left) ->
    if left == 1
      return final_move(me, base_score)
    #if left == 0
    # return base_score

    any_moves = false
    board.each_empty (pos) =>
      flips = board.move(me, pos)
      n = flips.length
      return true unless n
      any_moves = true
      score = base_score + 2*n + 1
      score = -solve_sub(-me, -upper, -lower, -score, 0, left-1)
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
        -solve_sub(-me, -upper, -lower, -base_score, 1, left)

  solve_sub = cached_solve solve_sub, board
  solve_sub(me, lower, upper, base_score, 0, left)

pattern_eval = require('./pattern_eval')('scores')

ordered_solve = (board, me, lower, upper, base_score, left) ->
  uct_eval = uct max_search: SHALLOW_SEARCH, evaluate: pattern_eval, verbose: false

  solve_sub = (me, lower, upper, base_score, pass, left) ->
    if left <= ORDER_THRESHOLD
      return simple_solve(board, me, lower, upper, base_score, left)

    {moves} = uct_eval board, me

    unless moves.length
      if pass
        if base_score > 0
          return base_score + left
        else if base_score < 0
          return base_score - left
      else
        return -solve_sub(-me, -upper, -lower, -base_score, 1, left)

    moves.sort (a, b) -> (b.n - a.n or b.value - a.value)

    for {move} in moves
      flips = board.move me, move
      score = base_score + 2*flips.length + 1
      if lower > -64 and upper - lower > 1 and left >= 12
        s = -solve_sub(-me, -(lower+1), -lower, -score, 0, left-1)
        if s > lower and s < upper
          s = -solve_sub(-me, -upper, -s, -score, 0, left-1)
        score = s
      else
        score = -solve_sub(-me, -upper, -lower, -score, 0, left-1)
      board.undo me, move, flips
      if score > lower
        lower = score
        if score >= upper
          break
    lower

  solve_sub = cached_solve solve_sub, board
  solve_sub(me, lower, upper, base_score, 0, left)

solve = (board, me, lower, upper) ->
  score = board.score(me)
  left = board.count(EMPTY)
  ordered_solve(board, me, lower, upper, score, left)

module.exports = (board, me, wld, verbose, moves=null) ->
  moves or= board.list_moves(me)

  left = board.count(EMPTY)
  n_search = 10000 * 2**(left - 19)
  if n_search > 400000
    n_search = 400000
  if n_search < 10000
    n_search = 10000
  console.log 'uct sort', n_search if verbose
  uct_eval = uct max_search: n_search, evaluate: pattern_eval, verbose: false
  uct_result = uct_eval(board, me)
  move_values = {}
  for move in uct_result.moves
    move_values[move.move] = move.n
  moves.sort (a, b) -> move_values[b] - move_values[a]

  if wld
    lower = -1
    upper = 1
  else
    lower = -64
    upper = 64

  best = 0
  for pos from moves
    flips = board.move(me, pos)
    console.assert flips.length
    process.stdout.write "#{pos_to_str(pos)}:" if verbose
    if lower > -64
      score = -solve(board, -me, -(lower+1), -lower)
      if score > lower and score < upper
        process.stdout.write '!' if verbose
        score = -solve(board, -me, -upper, -score)
    else
      score = -solve(board, -me, -upper, -lower)
    board.undo(me, pos, flips)
    if score > lower
      process.stdout.write "#{score} " if verbose
      lower = score
      best = pos
      if score >= upper
        break
    else
      process.stdout.write "* " if verbose
  process.stdout.write '\n' if verbose
  cache.stats() if verbose and CACHE

  if not best
    best = moves[0]

  {move:best, value:lower, solved:(if wld then 'wld' else 'full')}
