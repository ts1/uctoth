fs = require 'fs'
{ patterns, n_indexes, N_PHASES, N_MOVES_PER_PHASE } = require './pattern'
{ int } = require './util'

module.exports = (arg, invert=false) ->
  if typeof arg == 'string'
    scores = JSON.parse fs.readFileSync arg
  else
    scores = arg

  single_tbl = []
  for phase in [0...N_PHASES]
    tbl = []
    for p in patterns
      tbl = tbl.concat(scores[p.name][phase].slice(1).reverse().map((x) -> -x))
      tbl = tbl.concat(scores[p.name][phase])
    single_tbl[phase] = new Int16Array tbl

  pattern_eval = (board, me) ->
    phase = int((board.n_discs - 5) / N_MOVES_PER_PHASE)
    #phase = N_PHASES - 1 if phase >= N_PHASES
    tbl = single_tbl[phase]
    sum = 0
    for i in [0...n_indexes]
      sum += tbl[board.indexes[i]]
    sum *= me
    sum

  if invert
    (board, me) -> -pattern_eval(board, me)
  else
    pattern_eval
