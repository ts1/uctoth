fs = require 'fs'
{ patterns, n_indexes, N_PHASES, N_MOVES_PER_PHASE } = require './pattern'
{ int } = require './util'

module.exports = (score_filename) ->
  scores = JSON.parse fs.readFileSync score_filename

  index_to_scores = []
  for p in patterns
    for i in p.indexes
      index_to_scores[i] = scores[p.name]

  tables = []

  get_tables = (n) ->
    cache = tables[n]
    return cache if cache
    ph = (n - 5) / N_MOVES_PER_PHASE - 0.5
    if ph < 0
      phase1 = phase2 = 0
    else
      phase1 = int(ph)
      phase2 = phase1 + 1
    fraction = ph - phase1
    #console.log 'n',n,'phase1',phase1,'phase2',phase2,'fraction',fraction
    if phase1 < 0
      phase1 = 1
    if phase2 >= N_PHASES
      phase2 = N_PHASES - 1
    if phase1 == phase2 or fraction == 0
      #console.log 'copy tables for', phase1
      return tables[n] = copy_tables phase1
    else
      #console.log 'interpolate tables', phase1, 'and', phase2, 'with', fraction
      return tables[n] = interpolate_tables phase1, phase2, fraction

  copy_tables = (phase) ->
    table = []
    for p in patterns
      tbl = scores[p.name][phase]
      for i in p.indexes
        table[i] = tbl
    table

  interpolate_tables = (phase1, phase2, fraction) ->
    table = []
    for p in patterns
      tbl1 = scores[p.name][phase1]
      tbl2 = scores[p.name][phase2]
      tbl = []
      for i in [0...tbl1.length]
        a = tbl1[i]
        b = tbl2[i]
        tbl[i] = a * (1 - fraction) + b * fraction
      for i in p.indexes
        table[i] = tbl
    table

  (board, me) ->
    table = get_tables(board.n_discs)
    phase = int((board.n_discs - 5) / N_MOVES_PER_PHASE)
    phase = N_PHASES - 1 if phase >= N_PHASES
    board.set_parity me
    sum = 0
    for i in [0...n_indexes]
      index = board.indexes[i]
      tbl = table[i]
      if index >= 0
        sum += tbl[index]
      else
        sum -= tbl[-index]
    sum *= me
    sum
