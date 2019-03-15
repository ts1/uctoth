#!/usr/bin/env coffee
fs = require 'fs'
require './rejection_handler'
{ Board, BLACK, WHITE, EMPTY, pos_from_str, square_to_char, pos_to_str } = require './board'
{ PatternBoard } = require './pattern'
Player = require './player'
pattern_eval = require './pattern_eval'
{ decode } = require './encode'

defaults =
  verbose:false
  wld: 18
  full:16
  search: 40000
  ref: 'ref/weights.json'
  weights: 'weights.json'
  openings: 'match.openings'
  depth: 60
  leafs: 650000

module.exports = (options={}) ->
  opt = {defaults..., options...}

  normal_eval = pattern_eval(opt.weights)
  ref_eval = pattern_eval(opt.ref)

  simple = Player
    book: null
    strategy: require('./uct')
      evaluate: require('./simple_eval')
      verbose: opt.verbose
      board_class: Board
      max_search: opt.search
    solve_wld: opt.wld
    solve_full: opt.full
    verbose: opt.verbose
    endgame_eval: normal_eval

  minmax = Player
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

  uct = Player
    book: null
    strategy: require('./uct')
      evaluate: normal_eval
      verbose: opt.verbose
      max_search: opt.search
    solve_wld: opt.wld
    solve_full: opt.full
    verbose: opt.verbose
    endgame_eval: normal_eval

  uct_ref = Player
    book: null
    strategy: require('./uct')
      evaluate: ref_eval
      verbose: opt.verbose
      max_search: opt.search
    solve_wld: opt.wld
    solve_full: opt.full
    verbose: opt.verbose
    endgame_eval: ref_eval

  players = [uct]
  players.push if opt.minimax
                 minmax
               else if opt.simple
                 simple
               else
                 uct_ref

  play = (board, black, white) ->
    turn = if board.count(EMPTY) & 1 then WHITE else BLACK
    while true
      if opt.verbose
        console.log board.dump true
        console.log square_to_char(turn), 'to move'
        console.log square_to_char(BLACK), board.count(BLACK), 'discs', board.list_moves(BLACK).length, 'moves'
        console.log square_to_char(WHITE), board.count(WHITE), 'discs', board.list_moves(WHITE).length, 'moves'
        console.log square_to_char(EMPTY), board.count(EMPTY), 'squares'
      if board.any_moves(turn)
        switch turn
          when BLACK then player = black
          when WHITE then player = white
        {move, value} = player(board, turn)
        process.stdout.write pos_to_str(move, turn) unless opt.verbose
        flips = board.move turn, move
        console.assert flips.length
        console.log 'Estimated value', value if opt.verbose and value?
      else
        if board.any_moves(-turn)
          console.log 'PASS' if opt.verbose
        else
          process.stdout.write " #{ board.outcome()}\n" unless opt.verbose
          return board.outcome()
      turn = -turn

  wins = [0, 0]
  score = 0
  draws = 0

  do ->
    n_matches = 0
    sum_square_offset = 0
    for code in fs.readFileSync(opt.openings, 'utf8').trim().split('\n')
      b = decode code
      board = new PatternBoard b
      console.log board.dump true
      outcome = play board, players[0], players[1]
      score += outcome
      offset = outcome
      if outcome > 0
        wins[0]++
      else if outcome < 0
        wins[1]++
      else
        draws++
      n_matches++

      board = new PatternBoard b
      outcome = play board, players[1], players[0]
      score -= outcome
      offset += outcome
      if outcome > 0
        wins[1]++
      else if outcome < 0
        wins[0]++
      else
        draws++
      n_matches++

      offset /= 2
      sum_square_offset += offset * offset

      console.log 'player[0]', wins[0], 'wins'
      console.log 'player[1]', wins[1], 'wins'
      console.log 'draws', draws
      winrate = Math.round((wins[0] + draws/2) / n_matches * 100) / 100
      console.log 'win rate for player[0]', winrate
      avg = Math.round(score / n_matches * 10) / 10
      console.log 'avg score for player[0]', avg

    console.log 'average offset', Math.sqrt(sum_square_offset / n_matches)

    if opt.log
      fs.appendFileSync opt.log,
        "#{wins[0]} #{wins[1]} #{draws} #{winrate} #{avg}\n"

    { winrate, avg }

module.exports.defaults = defaults
