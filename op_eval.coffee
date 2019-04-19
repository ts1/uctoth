Player = require './player'

defaults =
  uct: false
  max_search: 3000
  depth: 13
  wld: 22
  full: 20

module.exports = (options={}) ->
  opt = {defaults..., options...}

  pattern_eval = require('./pattern_eval')('weights.json')

  if opt.uct
    do_evaluate = Player
      book: null
      strategy: require('./uct')
        verbose: false
        max_search: opt.max_search
        evaluate: pattern_eval
        by_value: true
      solve_wld: opt.wld - 1
      solve_full: opt.full - 1
      verbose: false
      endgame_eval: pattern_eval

    (board, turn, moves) ->
      max = -Infinity
      for pos in moves or board.list_moves(turn)
        flips = board.move(turn, pos)
        throw new Error unless flips.length
        if board.any_moves(-turn)
          { value, move, solved } = do_evaluate(board, -turn)
          value = 0 unless value?
          value = -value
        else
          { value, move, solved } = do_evaluate(board, turn)
          value = 0 unless value?
        board.undo turn, pos, flips
        if value > max
          max = value
          best = pos
          best_move = move

      if not solved and best_move > 0
        flips = board.move(turn, best)
        throw new Error unless flips.length
        if board.any_moves(-turn)
          { value } = do_evaluate(board, -turn, [best_move])
          value = 0 unless value?
          value = -value
        else
          { value } = do_evaluate(board, turn, [best_move])
          value = 0 unless value?
        board.undo turn, best, flips
        max = Math.round((max + value) / 2)

      { value: max, move: best, solved }
  else
    minmax = require './minmax'

    evaluator0 = Player
      book: null
      strategy: minmax
        verbose: false
        max_depth: opt.depth
        evaluate: pattern_eval
      solve_wld: opt.wld
      solve_full: opt.full
      verbose: false
      endgame_eval: pattern_eval

    evaluator1 = Player
      book: null
      strategy: minmax
        verbose: false
        max_depth: opt.depth - 1
        evaluate: pattern_eval
      solve_wld: opt.wld
      solve_full: opt.full
      verbose: false
      endgame_eval: pattern_eval

    (board, me, moves) ->
      { value, move, solved } = evaluator0(board, me, moves)
      value = 0 unless isFinite(value)
      
      unless solved
        ev1 = evaluator1(board, me, [move])
        ev1.value = 0 unless isFinite(ev1.value)
        value = Math.round((value + ev1.value) / 2)

      { value, move, solved }

module.exports.defaults = defaults
