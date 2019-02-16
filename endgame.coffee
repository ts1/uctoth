{ Board, EMPTY, pos_from_str, pos_to_xy, pos_from_xy, pos_to_str } = require './board'
{ SCORE_MULT } = require './pattern'
uct = require './uct'
{ INFINITY, lru_cache } = require './util'
{ PatternBoard } = require './pattern'

CACHE_MIN = 11
EARLY_CACHE_MIN = 16
ORDER_MIN = 10
CACHE_EXACT = 0
CACHE_UBOUND = 1
CACHE_LBOUND = -1

defaults =
  cache_size: 500000
  inverted: false
  verbose: true
  evaluate: null
  use_parity: true

module.exports = (options={}) ->
  opt = {defaults..., options...}
  
  calc_outcome = (score, left) ->
    if score > 0
      score + left
    else if score < 0
      score - left
    else
      0

  if opt.inverted
    calc_outcome = do ->
      orig = calc_outcome
      (score, left) -> -orig(score, left)

  if opt.cache_size
    cache = lru_cache(opt.cache_size)
    cache_put = (me, board, value, type) ->
      cache.put(board.key() + me, {value, type})
    cache_get = (me, board) -> cache.get(board.key() + me)
  else
    cache_put = ->
    cache_get = -> null

  if opt.use_parity
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

  final_move = (board, me, score, pos) ->
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

  if opt.inverted
    final_move = do ->
      orig = final_move
      (me, score) -> -orig(me, score)

  simple_solve = (board, me, lower, upper, base_score, left) ->
    board = new Board board

    solve_2_empty = (me, score, pass) ->
      emp1 = board.first_empty()
      emp2 = board.empty_next[emp1]
      best = -INFINITY

      flips = board.move me, emp1, false
      n = flips.length
      if n
        best = -final_move(board, -me, -(score + 2*n + 1), emp2)
        board.undo me, emp1, flips, false

      flips = board.move me, emp2, false
      n = flips.length
      if n
        s = -final_move(board, -me, -(score + 2*n + 1), emp1)
        if s > best
          best = s
        board.undo me, emp2, flips, false

      if best > -INFINITY
        best
      else if pass
        calc_outcome(score, 2)
      else
        -solve_2_empty(-me, -score, true)

    solve_sub = (me, lower, upper, base_score, pass, left) ->
      if left == 2
        return solve_2_empty(me, base_score, pass)

      max = -INFINITY
      any_moves = false

      [start, end, step] =
        if opt.use_parity
          if opt.inverted
            [0, 1, 1]
          else
            [1, 0, -1]
        else
          [0, 0, 1]

      for parity in [start..end] by step
        board.each_empty (pos) =>
          return true if opt.use_parity and parity_tbl[parity_index[pos]] != parity
          flips = board.move(me, pos)
          n = flips.length
          return true unless n
          update_parity(board, pos) if opt.use_parity
          any_moves = true
          score = base_score + 2*n + 1
          score = -solve_sub(-me, -upper, -lower, -score, 0, left-1)
          board.undo me, pos, flips
          update_parity(board, pos) if opt.use_parity
          if score > max
            max = score
            if score > lower
              lower = score
              return false if score >= upper # stop iteration
          true # continue iteration
        break if lower >= upper
      if any_moves
        max
      else
        if pass
          calc_outcome(base_score, left)
        else
          -solve_sub(-me, -upper, -lower, -base_score, 1, left)

    init_parity(board) if opt.use_parity

    solve_sub(me, lower, upper, base_score, 0, left)

  ordered_solve = (board, me, lower, upper, base_score, left) ->
    solve_sub = (me, lower, upper, base_score, pass, left) ->
      if left < ORDER_MIN
        return simple_solve(board, me, lower, upper, base_score, left)

      orig_lower = lower

      if left >= CACHE_MIN
        data = cache_get(me, board)
        if data
          switch data.type
            when CACHE_EXACT
              return data.value
            when CACHE_UBOUND
              if data.value <= lower
                return data.value
            when CACHE_LBOUND
              if data.value >= upper
                return data.value

      moves = []
      board.each_empty (pos) ->
        flips = board.move me, pos
        if flips.length
          moves.push
            move: pos
            mobility: board.count_moves(-me)
            value: opt.evaluate(board, me)
          board.undo me, pos, flips

      unless moves.length
        if pass
          score = calc_outcome(base_score, left)
          if left >= CACHE_MIN
            cache_put(me, board, score, CACHE_EXACT)
          return score
        else
          return -solve_sub(-me, -upper, -lower, -base_score, 1, left)

      moves.sort (a, b) -> a.mobility - b.mobility or b.value - a.value

      if left >= EARLY_CACHE_MIN
        for {move} in moves
          flips = board.move me, move, false
          c = cache_get(-me, board)
          board.undo me, move, flips, false
          if c and c.type != CACHE_LBOUND and -c.value >= upper
            cache_put(me, board, -c.value, CACHE_LBOUND)
            return -c.value

      max = -INFINITY
      for {move} in moves
        flips = board.move me, move
        score = base_score + 2*flips.length + 1
        score = -solve_sub(-me, -upper, -lower, -score, 0, left-1)
        board.undo me, move, flips
        if score > max
          max = score
          if score > lower
            lower = score
            if score >= upper
              break

      if left >= CACHE_MIN
        if max >= upper
          cache_put(me, board, max, CACHE_LBOUND)
        else if max <= orig_lower
          cache_put(me, board, max, CACHE_UBOUND)
        else
          cache_put(me, board, max, CACHE_EXACT)

      max

    solve_sub(me, lower, upper, base_score, 0, left)

  mtdf = (board, me, lower, upper, first_guess) ->
    score = board.score(me)
    left = board.count(EMPTY)
    l = lower
    u = upper
    guess = Math.round(first_guess / 2) * 2
    guess = l if guess < l
    guess = u if guess > u
    while l < u
      process.stdout.write "(#{guess})" if opt.verbose
      beta = if guess == l then l+2 else guess
      value = ordered_solve(board, me, beta-2, beta, score, left)
      #process.stdout.write "#{value}" if opt.verbose
      if value >= beta
        if value >= upper
          return value
        l = value
      else
        if value <= lower
          return value
        u = value
      guess = value
    value

  (board, me, wld, moves=null) ->
    board = new PatternBoard board

    moves or= board.list_moves(me)

    left = board.count(EMPTY)
    n_search = 10000 * 3**(left - 20)
    if n_search > 400000
      n_search = 400000
    if n_search < 10000
      n_search = 10000
    console.log 'uct sort', n_search if opt.verbose

    uct_eval = uct
      max_search: n_search
      evaluate: opt.evaluate
      verbose: false
      inverted: opt.inverted
    uct_result = uct_eval(board, me)

    move_values = {}
    for move in uct_result.moves
      move_values[move.move] = move.n
    moves.sort (a, b) -> move_values[b] - move_values[a]

    first_guess = uct_result.value / SCORE_MULT

    if wld
      lower = -2
      upper = 2
    else
      lower = -64
      upper = 64

    best = 0
    for pos from moves
      flips = board.move(me, pos)
      console.assert flips.length
      process.stdout.write "#{pos_to_str(pos)}" if opt.verbose
      score = -mtdf(board, -me, -upper, -lower, -first_guess)
      board.undo(me, pos, flips)
      if score > lower
        process.stdout.write ":#{score} " if opt.verbose
        lower = score
        best = pos
        if score >= upper
          break
      else
        process.stdout.write " " if opt.verbose
      first_guess = lower
    process.stdout.write '\n' if opt.verbose
    console.log cache.stats() if opt.verbose and opt.cache_size

    if not best
      best = moves[0]

    {move:best, value:lower, solved:(if wld then 'wld' else 'full')}
