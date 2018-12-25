fs = require 'fs'
{ patterns, n_indexes, N_PHASES, N_MOVES_PER_PHASE } = require './pattern'
{ int } = require './util'

module.exports = (arg, invert=false) ->
  if typeof arg == 'string'
    scores = JSON.parse fs.readFileSync arg
  else
    scores = arg

  scores.parity = ([0,0] for i in [0...10])

  index_to_scores = []
  for p in patterns
    for i in p.indexes
      index_to_scores[i] = scores[p.name]

  pattern_eval = (board, me) ->
    phase = int((board.n_discs - 5) / N_MOVES_PER_PHASE)
    phase = N_PHASES - 1 if phase >= N_PHASES
    board.set_parity me
    sum = 0
    for i in [0...n_indexes]
      index = board.indexes[i]
      tbl = index_to_scores[i]
      if index >= 0
        sum += tbl[phase][index]
      else
        sum -= tbl[phase][-index]
    sum *= me
    sum

  if invert
    (board, me) -> -pattern_eval(board, me)
  else
    pattern_eval
