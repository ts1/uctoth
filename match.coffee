#!/usr/bin/env coffee
fs = require 'fs'
require './rejection_handler'
{ Board, BLACK, WHITE, EMPTY, pos_from_str, square_to_char, pos_to_str } = require './board'
{ PatternBoard } = require './pattern'
Player = require './player'
pattern_eval = require './pattern_eval'
{ decode, encode } = require './encode'
uct_defaults = require('./uct').defaults
ext = require './ext'

defaults =
  verbose: false
  quiet: false
  wld: 18
  full: 16
  search: 40000
  ref: 'ref/weights.json'
  weights: 'weights.json'
  openings: 'match.openings'
  depth: 60
  leafs: 650000
  both_minimax: false
  C: uct_defaults.C
  C_log: uct_defaults.C_log

module.exports = (options={}) ->
  opt = {defaults..., options...}
  opt.verbose = false if opt.quiet

  normal_eval = pattern_eval(opt.weights)
  ref_eval = pattern_eval(opt.ref)

  players = []

  players[0] =
    if opt.both_minimax
      Player
        book: null
        strategy: require('./minmax')
          evaluate: normal_eval
          max_depth: opt.depth
          max_leafs: opt.leafs
          shuffle: false
          verbose: opt.verbose
        solve_wld: opt.wld
        solve_full: opt.full
        verbose: opt.verbose
        endgame_eval: normal_eval
    else
      Player
        book: null
        strategy: require('./uct')
          evaluate: normal_eval
          verbose: opt.verbose
          max_search: opt.search
          C: opt.C
          C_log: opt.C_log
        solve_wld: opt.wld
        solve_full: opt.full
        verbose: opt.verbose
        endgame_eval: normal_eval

  players[1] =
    if opt.both_minimax
      Player
        book: null
        strategy: require('./minmax')
          evaluate: ref_eval
          max_depth: opt.depth
          max_leafs: opt.leafs
          shuffle: false
          verbose: opt.verbose
        solve_wld: opt.wld
        solve_full: opt.full
        verbose: opt.verbose
        endgame_eval: ref_eval
    else if opt.minimax
      Player
        book: null
        strategy: require('./minmax')
          evaluate: normal_eval
          max_depth: opt.depth
          max_leafs: opt.leafs
          shuffle: false
          verbose: opt.verbose
        solve_wld: opt.wld
        solve_full: opt.full
        verbose: opt.verbose
        endgame_eval: normal_eval
    else if opt.simple
      Player
        book: null
        strategy: require('./uct')
          evaluate: require('./simple_eval')
          verbose: opt.verbose
          board_class: Board
          max_search: opt.search
          C: opt.C
          C_log: opt.C_log
        solve_wld: opt.wld
        solve_full: opt.full
        verbose: opt.verbose
        endgame_eval: normal_eval
    else
      Player
        book: null
        strategy: require('./uct')
          evaluate: ref_eval
          verbose: opt.verbose
          max_search: opt.search
        solve_wld: opt.wld
        solve_full: opt.full
        verbose: opt.verbose
        endgame_eval: ref_eval

  play = (board, black, white) ->
    turn = if board.count(EMPTY) & 1 then WHITE else BLACK
    while true
      if opt.verbose
        console.log board.dump true
        console.log square_to_char(turn), 'to move'
        console.log square_to_char(BLACK), board.count(BLACK), 'discs',
          board.list_moves(BLACK).length, 'moves'
        console.log square_to_char(WHITE), board.count(WHITE), 'discs',
          board.list_moves(WHITE).length, 'moves'
        console.log square_to_char(EMPTY), board.count(EMPTY), 'squares'
      if board.any_moves(turn)
        switch turn
          when BLACK then player = black
          when WHITE then player = white
        {move, value} = player(board, turn)
        unless opt.verbose or opt.quiet
          process.stdout.write pos_to_str(move, turn)
        flips = board.move turn, move
        console.assert flips.length
        console.log 'Estimated value', value if opt.verbose and value?
      else
        if board.any_moves(-turn)
          console.log 'PASS' if opt.verbose
        else
          unless opt.verbose or opt.quiet
            process.stdout.write " #{ board.outcome()}\n"
          return board.outcome()
      turn = -turn

  wins = [0, 0]
  score = 0
  draws = 0

  do ->
    n_matches = 0
    sum_square_offset = 0
    openings =
      if opt.openings
        fs.readFileSync(opt.openings, 'utf8').trim().split('\n')
      else
        [encode(new Board)]
    for code in openings
      b = decode code

      ext.reset_hash() if ext.is_enabled and ext.reset_hash?
      board = new PatternBoard b
      console.log board.dump true unless opt.quiet
      outcome = play board, players[0], players[1]
      score += outcome
      offset = outcome
      if outcome > 0
        wins[0]++
        process.stdout.write '+' if opt.quiet
      else if outcome < 0
        wins[1]++
        process.stdout.write '-' if opt.quiet
      else
        draws++
        process.stdout.write '0' if opt.quiet
      n_matches++

      if opt.min?
        ubound = wins[0] + draws / 2 + (openings.length * 2 - n_matches)
        if ubound < Math.floor(opt.min * openings.length)
          break

      ext.reset_hash() if ext.is_enabled and ext.reset_hash?
      board = new PatternBoard b
      outcome = play board, players[1], players[0]
      score -= outcome
      offset += outcome
      if outcome > 0
        wins[1]++
        process.stdout.write '-' if opt.quiet
      else if outcome < 0
        wins[0]++
        process.stdout.write '+' if opt.quiet
      else
        draws++
        process.stdout.write '0' if opt.quiet
      n_matches++

      if opt.min?
        ubound = wins[0] + draws / 2 + (openings.length * 2 - n_matches)
        if ubound < Math.floor(opt.min * openings.length)
          break

      offset /= 2
      sum_square_offset += offset * offset

      unless opt.quiet
        console.log 'player[0]', wins[0], 'wins' unless opt.quiet
        console.log 'player[1]', wins[1], 'wins' unless opt.quiet
        console.log 'draws', draws unless opt.quiet
      winrate = Math.round((wins[0] + draws/2) / n_matches * 100) / 100
      console.log 'win rate for player[0]', winrate unless opt.quiet
      avg = Math.round(score / n_matches * 10) / 10
      console.log 'avg score for player[0]', avg unless opt.quiet

    process.stdout.write ' ' if opt.quiet
    unless opt.quiet
      console.log 'average offset', Math.sqrt(sum_square_offset / n_matches)

    if opt.log
      fs.appendFileSync opt.log,
        "#{wins[0]} #{wins[1]} #{draws} #{winrate} #{avg}\n"

    { winrate, avg }

module.exports.defaults = defaults
