import { Board } from '@oth/board'
import pattern_eval from '@oth/pattern_eval'
import make_player from '@oth/player'
import uct from '@oth/uct'
import scores from './scores.json'

player = null

param_table =
  easiest:
    search: 2000
    random: 0
    invert: true
    wld: 15
    full: 13
  easy:
    search: 1
    random: .1
    wld: 0
    full: 0
  normal:
    book: true
    book_random: 1
    search: 1
    random: 0
    wld: 0
    full: 0
  hard:
    book: true
    book_random: .7
    search: 5
    random: 0
    wld: 10
    full: 8
  hardest:
    book: true
    book_random: .1
    search: 100000
    random: 0
    wld: 20
    full: 18

set_level = (level) ->
  params = param_table[level]
  unless params
    throw new Error "invalid level #{level}"
  {search, wld, full, invert, random, book, book_random} = params

  evaluate = if invert then pattern_eval(scores, true) else pattern_eval(scores)
  if book
    book = require('@oth/static_book_player')
      random: book_random
      #verbose: false

  player = make_player
    shuffle: true
    book: book
    strategy: uct
      evaluate: evaluate
      max_search: search
      random: random
      verbose: false
      inverted: invert ? false
    verbose: false
    inverted: invert ? false
    endgame_eval: evaluate
    solve_wld: wld
    solve_full: full

self.onmessage = (e) ->
  switch e.data.type
    when 'set_level'
      { level } = e.data
      set_level level
    when 'move'
      unless player
        throw new Error 'level not set'
      {board, turn} = e.data
      board = new Board board
      result = await player(board, turn)
      self.postMessage result
    else
      throw new Error "message type unknown: #{e.data.type}"
