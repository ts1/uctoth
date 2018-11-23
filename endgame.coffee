{ Board, EMPTY, pos_from_str, pos_to_xy, pos_from_xy, ALL_POSITIONS } = require './board'

SEARCH_ORDER = do ->
  # Search order of moves for upper left quarter of board,
  # possibly strongest first.
  QUARTER_ORDER = [
    'A1', # corner
    'C3',
    'C1', 'A3',
    'D1', 'A4',
    'D3', 'C4',
    'D2', 'B4',
    'B1', 'A2',
    'C2', 'B3',
    'B2' # X
    'D4' # just in case
  ]
  order = []
  for spos in QUARTER_ORDER
    pos = pos_from_str(spos)
    {x, y} = pos_to_xy(pos)
    order.push pos_from_xy(x, y)
    order.push pos_from_xy(7-x, y)
    order.push pos_from_xy(x, 7-y)
    order.push pos_from_xy(7-x, 7-y)
  order

build_empty_list = (board) ->
  empty_list = {}
  prev = 0
  for pos in SEARCH_ORDER
    if board.get(pos) == EMPTY
      empty_list[prev] = pos
      prev = pos
  empty_list[prev] = 0
  empty_list

each_empty = (empty_list, fn) ->
  prev = 0
  while (pos = empty_list[prev]) != 0
    empty_list[prev] = empty_list[pos]
    result = fn(pos)
    empty_list[prev] = pos
    prev = pos
    if result == false
      break

cache = require('./cache')(100000)

cached_solve = (f, board) ->
  (me, lower, upper, score, pass, left) ->
    if left <= 9
      return f me, lower, upper, score, pass, left

    value = cache.get(board, me, left, lower, upper)
    if value != null
      return value

    value = f me, lower, upper, score, pass, left

    cache.set board, me, left, lower, upper, value
    value

simple_solve = (board, me, lower, upper, base_score, left) ->
  board = new Board board
  empty_list = build_empty_list(board)

  solve = (me, lower, upper, base_score, pass, left) =>
    if left == 0
      return base_score
    any_moves = false
    each_empty empty_list, (pos) =>
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
    if left <= 10
      return simple_solve(board, me, lower, upper, base_score, left)

    moves = []
    for pos in ALL_POSITIONS
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

module.exports = (board, me, lower, upper, evaluator) ->
  #cache.stats()
  score = board.score(me)
  left = board.count(EMPTY)
  if evaluator
    ordered_solve(board, me, lower, upper, score, left, evaluator)
  else
    simple_solve(board, me, lower, upper, score, left)
