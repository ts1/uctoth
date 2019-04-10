fs = require 'fs'
{ patterns, n_indexes, N_PHASES, N_MOVES_PER_PHASE, SCORE_MULT } = require './pattern'
{ int } = require './util'
{ LOG_MULT } = require './logutil'

module.exports = (arg, invert=false) ->
  if typeof arg == 'string'
    weights = JSON.parse fs.readFileSync arg
  else
    weights = arg

  single_tbl = []
  offsets = []
  for phase in [0...N_PHASES]
    tbl = []
    for p in patterns
      tbl = tbl.concat(weights[p.name][phase].slice(1).reverse().map((x) -> -x))
      tbl = tbl.concat(weights[p.name][phase])
    if weights.clip == 16
      single_tbl[phase] = new Int16Array tbl
    else
      single_tbl[phase] = tbl
    offset = weights.meta[phase].offset or 0
    offset *= if weights.meta[phase].logistic then LOG_MULT else SCORE_MULT
    offsets[phase] = Math.round(offset)

  pattern_eval = (board, me) ->
    phase = int((board.n_discs - 5) / N_MOVES_PER_PHASE)
    tbl = single_tbl[phase]
    sum = offsets[phase]
    for i in [0...n_indexes]
      sum += tbl[board.indexes[i]]
    sum * me

  if invert
    pattern_eval = do ->
      orig = pattern_eval
      (board, me) -> -orig(board, me)

  pattern_eval.logistic = weights.meta[0].logistic
  pattern_eval.weights = weights

  pattern_eval
