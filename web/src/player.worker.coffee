import { Board } from '@oth/board'
import pattern_eval from '@oth/pattern_eval'
import make_player from '@oth/player'
import uct from '@oth/uct'
import scores from './scores.json'

evaluate = pattern_eval(scores)
player = null

make_player_with_params = () ->

param_table =
  easiest:
    search: 10000
    wld: 0
    full: 0
    invert: true
  easy:
    search: 1
    wld: 0
    full: 0
    random: true
  normal:
    search: 1
    wld: 0
    full: 0
  hard:
    search: 10000
    wld: 14
    full: 16
  hardest:
    search: 200000
    wld: 15
    full: 17

set_level = (level) ->
  params = param_table[level]
  unless params
    throw new Error "invalid level #{level}"
  {search, wld, full, invert, random} = params

  player = make_player
    book: null
    strategy: uct
      evaluate:
        if invert
          pattern_eval(scores, true)
        else if random
          -> Math.random()
        else
          evaluate
      max_search: search
      verbose: false
    verbose: false
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
