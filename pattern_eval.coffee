fs = require 'fs'
{ patterns, n_indexes, N_PHASES, N_MOVES_PER_PHASE } = require './pattern'
{ int } = require './util'

module.exports = (arg, invert=false) ->
  if typeof arg == 'string'
    weights = JSON.parse fs.readFileSync arg
  else
    weights = arg

  #console.log 'making single tables', arg
  single_tbl = []
  for phase in [0...N_PHASES]
    tbl = []
    for p in patterns
      tbl = tbl.concat(weights[p.name][phase].slice(1).reverse().map((x) -> -x))
      tbl = tbl.concat(weights[p.name][phase])
    if weights.clip == 16
      single_tbl[phase] = new Int16Array tbl
    else
      single_tbl[phase] = tbl

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
    pattern_eval = (board, me) -> -pattern_eval(board, me)

  pattern_eval.logistic = weights.meta[0].logistic
  pattern_eval
