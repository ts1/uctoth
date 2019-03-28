#!/usr/bin/env coffee
fs = require 'fs'
{ N_PHASES, patterns, get_single_index, get_single_index_size } = require './pattern'
{ int } = require './util'
{ SCORE_MULT } = require './pattern'
{ LOG_MULT } = require './logutil'

defaults =
  prefix: 'tmp/coeffs'
  outfile: 'weights.json'
  verbose: true
  array: null

module.exports = (options) ->
  opt = { defaults..., options... }
  init_weights = ->
    weights = {}
    for p in patterns
      weights[p.name] = []
      for phase in [0...N_PHASES]
        weights[p.name][phase] = []
        for i in [0...(3**p.len+1)/2]
          weights[p.name][phase][i] = 0
    weights

  logistic = null

  load_coeffs = (weights) ->
    for phase in [0...N_PHASES]
      if opt.array
        result = opt.array[phase]
      else
        result = JSON.parse fs.readFileSync "#{opt.prefix}#{phase}"
      logistic = result.logistic
      {coeffs} = result
      for i in [0...get_single_index_size()]
        {pattern, index} = get_single_index(i)
        weights[pattern][phase][index] = coeffs[i]
      weights.meta or= []
      meta = { result.coeffs... }
      delete meta.coeffs
      weights.meta[phase] = meta

  interpolate = (weights) ->
    for p in patterns
      tbl = weights[p.name]
      for phase in [0...N_PHASES]
        for i in [0...(3**p.len+1)/2]
          if not tbl[phase][i]
            for d in [0...N_PHASES]
              if phase-d >= 0 and tbl[phase-d][i] != 0
                tbl[phase][i] = tbl[phase-d][i]
                #console.log "#{p.name} #{i} #{phase-d}-->#{phase}"
                break
              else if phase+d < N_PHASES and tbl[phase+d][i] != 0
                tbl[phase][i] = tbl[phase+d][i]
                #console.log "#{p.name} #{i} #{phase+d}-->#{phase}"
                break

  denormalize = (weights) ->
    for p in patterns
      for phase in [0...N_PHASES]
        tbl = weights[p.name][phase]
        for i in [0...(3**p.len+1)/2]
          r = p.normalize i
          if r != i
            if r >= 0
              tbl[i] = tbl[r]
            else
              tbl[i] = -tbl[-r]

  round = (weights) ->
    clip = 0
    rms = 0
    zero = 0
    n = 0
    max = 0
    MIN = -32768
    MAX = 32767
    mult = if logistic then LOG_MULT else SCORE_MULT
    for p in patterns
      for phase in [0...N_PHASES]
        tbl = weights[p.name][phase]
        for i in [0...(3**p.len+1)/2]
          orig_val = tbl[i]
          val = Math.round(tbl[i] * mult)
          val = MAX if val > MAX
          val = MIN if val < MIN
          tbl[i] = val

          clip++ if val == MIN or val == MAX
          zero++ if val == 0 and orig_val != 0
          if val
            rms += val*val
            n++
          max = Math.abs(val) if Math.abs(val) > max
    rms = Math.sqrt(rms / n)
    {rms, clip, zero, max}

  process.stdout.write 'Wrapping up: ' if opt.verbose
  weights = init_weights()
  load_coeffs weights
  interpolate weights
  denormalize weights
  stats = round weights
  weights.clip = 16
  weights.stats = stats
  weights.logistic = logistic
  fs.writeFileSync opt.outfile, JSON.stringify weights
  console.log "'#{opt.outfile}' is ready" if opt.verbose
  console.log stats if opt.verbose

module.exports.defaults = defaults
