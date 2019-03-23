import { Board, pos_to_str } from '@oth/board'
import pattern_eval from '@oth/pattern_eval'
import make_player from '@oth/player'
import uct from '@oth/uct'
import minmax from '@oth/minmax'
import weights from './weights.json'
import { ready } from '@oth/ext/wasm-glue'

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
    random: 1
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
    random: .01
    wld: 8
    full: 6
  hardest:
    book: true
    book_random: .1
    search: 100000
    random: 0
    wld: 20
    full: 18
    wasm_wld: 22
    wasm_full: 20

set_level = (level, wasm) ->
  params = param_table[level]
  unless params
    throw new Error "invalid level #{level}"
  {search, wld, full, invert, random, book, book_random, depth
    wasm_wld, wasm_full } = params

  evaluate = if invert then pattern_eval(weights, true) else pattern_eval(weights)
  if book
    book = require('@oth/static_book_player')
      random: book_random

  strategy =
    if depth?
      minmax
        evaluate: evaluate
        max_depth: depth
        verbose: false
        invert: invert
    else
      uct
        evaluate: evaluate
        max_search: search
        random: random
        verbose: false
        inverted: invert
        show_cache: true

  player = make_player
    shuffle: true
    book: book
    strategy: strategy
    verbose: false
    inverted: invert
    endgame_eval: evaluate
    endgame_weights: weights
    solve_wld: wasm and wasm_wld or wld
    solve_full: wasm and wasm_full or full

shown = false

self.onmessage = (e) ->
  try
    await ready
    console.log 'wasm is ready!' unless shown
    wasm = true
  catch
    console.log 'wasm is not available' unless shown
    wasm = false
  shown = true

  switch e.data.type
    when 'set_level'
      { level } = e.data
      set_level level, wasm
    when 'move'
      unless player
        throw new Error 'level not set'
      {board, turn} = e.data
      board = new Board board
      result = await player(board, turn)
      self.postMessage result
    else
      throw new Error "message type unknown: #{e.data.type}"
