fs = require 'fs'
{ patterns, n_indexes, N_PHASES, N_MOVES_PER_PHASE } = require './pattern'
{ int } = require './util'

module.exports = (score_filename) ->
  scores = JSON.parse fs.readFileSync score_filename

  scores.offset or= ([0,0] for i in [0...N_PHASES])
  scores.turn or= ([0,0] for i in [0...N_PHASES])

  index_to_scores = []
  for p in patterns
    for i in p.indexes
      index_to_scores[i] = scores[p.name]

  (board, me) ->
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
