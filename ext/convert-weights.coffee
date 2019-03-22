fs = require 'fs'
{ patterns, n_indexes, N_PHASES, N_MOVES_PER_PHASE } = require '../pattern'
{ int } = require '../util'

convert_index = (index, p) ->
  mult = 1
  result = 0
  for i in [0...p.len]
    val = index % 3
    index = int(index / 3)
    val = -1 if val == 2
    result += val * mult
    mult *= 3
  result

convert_tbl = (orig_tbl, p) ->
  len = 3**p.len
  tbl = []
  for i in [0...len]
    index = convert_index i, p
    if index >= 0
      tbl[i] = orig_tbl[index]
    else
      tbl[i] = -orig_tbl[-index]

module.exports = (weights) ->
  if typeof weights == 'string'
    weights = JSON.parse fs.readFileSync weights

  for phase in [0...N_PHASES]
    tbl = []
    for p in patterns
      tbl = tbl.concat convert_tbl(weights[p.name][phase], p)
    Int16Array.from tbl
