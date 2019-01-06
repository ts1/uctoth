{ Board, EMPTY, pos_from_str, pos_to_xy, pos_from_xy, pos_to_str } = require './board'
uct = require './uct'

CACHE_SIZE = 500000
CACHE = true
CACHE_THRESHOLD = 8
ORDER_THRESHOLD = 9
SHALLOW_SEARCH = 6
USE_MTDF = true
USE_PARITY = true

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

if USE_PARITY
  parity_index = []
  for x in [0..3]
    for y in [0..3]
      parity_index[pos_from_xy x, y] = 0
  for x in [4..7]
    for y in [0..3]
      parity_index[pos_from_xy x, y] = 1
  for x in [0..3]
    for y in [4..7]
      parity_index[pos_from_xy x, y] = 2
  for x in [4..7]
    for y in [4..7]
      parity_index[pos_from_xy x, y] = 3

  parity_tbl = null

  init_parity = (board) ->
    parity_tbl = [0, 0, 0, 0]
    board.each_empty (pos) ->
      parity_tbl[parity_index[pos]] ^= 1

  update_parity = (board, pos) ->
    parity_tbl[parity_index[pos]] ^= 1


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
    p = if USE_PARITY then 1 else 0
    for parity in [p..0] by -1
      board.each_empty (pos) =>
        return true if USE_PARITY and parity_tbl[parity_index[pos]] != parity
        flips = board.move(me, pos)
        n = flips.length
        return true unless n
        update_parity(board, pos) if USE_PARITY
        any_moves = true
        score = base_score + 2*n + 1
        score = -solve_sub(-me, -upper, -lower, -score, 0, left-1)
        board.undo me, pos, flips
        update_parity(board, pos) if USE_PARITY
        if score > lower
          lower = score
          return false if score >= upper # stop iteration
        true # continue iteration
      break if lower >= upper
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

  init_parity(board) if USE_PARITY

  solve_sub = cached_solve solve_sub, board
  solve_sub(me, lower, upper, base_score, 0, left)

ordered_solve = (board, me, lower, upper, base_score, left, evaluate) ->
  uct_eval = uct max_search: SHALLOW_SEARCH, evaluate: evaluate, verbose: false

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

    for move in moves
      flips = board.move me, move.move
      move.mobility = board.count_moves(-me)
      board.undo me, move.move, flips

    moves.sort (a, b) ->
      a.mobility - b.mobility or b.n - a.n or b.value - a.value

    for {move} in moves
      flips = board.move me, move
      score = base_score + 2*flips.length + 1
      if not USE_MTDF and lower > -64 and upper - lower > 1 and left >= 12
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

solve = (board, me, lower, upper, evaluate) ->
  score = board.score(me)
  left = board.count(EMPTY)
  ordered_solve(board, me, lower, upper, score, left, evaluate)

mtdf = (board, me, lower, upper, evaluate, first_guess, verbose) ->
  score = board.score(me)
  left = board.count(EMPTY)
  l = lower
  u = upper
  guess = Math.round(first_guess / 2) * 2
  guess = l if guess < l
  guess = u if guess > u
  while l < u
    #process.stdout.write "[#{l},#{u}](#{guess})" if verbose
    beta = if guess == l then l+2 else guess
    value = ordered_solve(board, me, beta-2, beta, score, left, evaluate)
    #process.stdout.write "#{value}" if verbose
    if value >= beta
      if value >= upper
        return value
      l = value
    else
      if value <= lower
        return value
      u = value
    guess = Math.round((l+u)/4) * 2
  value

module.exports = (board, me, wld, verbose, evaluate, moves=null) ->
  moves or= board.list_moves(me)

  left = board.count(EMPTY)
  n_search = 10000 * 3**(left - 18)
  if n_search > 400000
    n_search = 400000
  if n_search < 10000
    n_search = 10000
  console.log 'uct sort', n_search if verbose
  uct_eval = uct max_search: n_search, evaluate: evaluate, verbose: false
  uct_result = uct_eval(board, me)
  move_values = {}
  for move in uct_result.moves
    move_values[move.move] = move.n
  moves.sort (a, b) -> move_values[b] - move_values[a]

  first_guess = uct_result.value

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
    process.stdout.write "#{pos_to_str(pos)}" if verbose
    if USE_MTDF
      score = -mtdf(board, -me, -upper, -lower, evaluate, -first_guess, verbose)
    else
      if lower > -64
        score = -solve(board, -me, -(lower+2), -lower, evaluate)
        if score > lower and score < upper
          process.stdout.write ':\b' if verbose
          score = -solve(board, -me, -upper, -score, evaluate)
      else
        score = -solve(board, -me, -upper, -lower, evaluate)
    board.undo(me, pos, flips)
    if score > lower
      process.stdout.write ":#{score} " if verbose
      lower = score
      best = pos
      if score >= upper
        break
    else
      process.stdout.write " " if verbose
    first_guess = lower
  process.stdout.write '\n' if verbose
  cache.stats() if verbose and CACHE

  if not best
    best = moves[0]

  {move:best, value:lower, solved:(if wld then 'wld' else 'full')}
