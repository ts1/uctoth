#!/usr/bin/env coffee

{ get_single_index_size, code_to_single_indexes } = require './pattern'
{ LOG_MULT } = require './logutil'
{ shuffle } = require './util'
Book = require './book'
fs = require 'fs'

defaults =
  book: 'book.db'
  epochs: 100
  l2: 0.5
  search_precision: 1.1
  search_max: 2
  search_min: 0.001
  verbose: true

INDEX_SIZE = get_single_index_size()

load_samples = (opt) ->
  book = new Book opt.book, close_on_exit: false
  book.init()
  if opt.verbose
    process.stdout.write "Loading samples for phase #{opt.phase}: "
  samples = shuffle(sample for sample from book.iterate_indexes(opt.phase))
  if opt.logistic
    samples.forEach (sample) ->
      sample[0] = if sample[0] > 0 then .99 else 0.01
  console.log "loaded #{samples.length} samples" if opt.verbose
  book.close()
  samples

clip = do ->
  MAX = 32767 / LOG_MULT
  MIN = -32768 / LOG_MULT
  (x) ->
    if x > MAX then MAX
    else if x < MIN then MIN
    else x

split_groups = (samples, k) ->
  win_set = shuffle(samples.filter (sample) -> sample[0] > 0)
  loss_set = shuffle(samples.filter (sample) -> sample[0] <= 0)

  win_per_group = Math.round(win_set.length / k)
  win_groups =
    for i in [0...k]
      win_set[i*win_per_group...(i + 1)*win_per_group]

  loss_per_group = Math.round(loss_set.length / k)
  loss_groups =
    for i in [0...k]
      loss_set[i*win_per_group...(i + 1)*loss_per_group]

  groups =
    for i in [0...k]
      shuffle(win_groups[i].concat(loss_groups[i]))

  groups

module.exports = (options={}) ->
  opt = {defaults..., options...}
  throw new Error 'phase option is required' unless opt.phase?

  predict = do ->
    do_predict = (indexes, coeffs) ->
      result = 0
      for i in [1...indexes.length] by 2
        index = indexes[i]
        value = indexes[i+1]
        result += coeffs[index] * value
      result

    if opt.logistic
      (indexes, coeffs) -> 1 / (1 + Math.exp(-do_predict(indexes, coeffs)))
    else
      do_predict

  make_gradient = (batch, coeffs) ->
    gradient = (0 for i in [0...INDEX_SIZE])
    e2 = 0
    for indexes in batch
      outcome = indexes[0]
      e = predict(indexes, coeffs) - outcome
      for i in [1...indexes.length] by 2
        index = indexes[i]
        value = indexes[i+1]
        g = e * value
        gradient[index] -= g
      e2 += e * e
    {gradient, e2}

  verify = (samples, coeffs) ->
    e2 = 0
    for indexes in samples
      outcome = indexes[0]
      e = predict(indexes, coeffs) - outcome
      e2 += e * e
    Math.sqrt(e2 / samples.length)

  epoch = (samples, coeffs, g2, rate, batch_size, max_loss=Infinity) ->
    max_e2 = max_loss**2 * samples.length
    sum_e2 = 0
    n_batches = Math.ceil(samples.length / batch_size)
    for offset in [0...n_batches]
      batch = (samples[i] for i in [offset...samples.length] by n_batches)
      {gradient, e2} = make_gradient(batch, coeffs)
      sum_e2 += e2
      return false if sum_e2 >= max_e2
      for i in [0...INDEX_SIZE]
        g = gradient[i]
        continue unless g
        g2[i] += g * g
        w = coeffs[i]
        g -= opt.l2 * w
        w += rate/Math.sqrt(g2[i]) * g
        coeffs[i] = clip(w)
    return true

  find_rate = (samples, batch_size, dev) ->
    # rough tune
    min_loss = dev
    best_rate = null
    rate = 1
    step_size = 10
    loop
      coeffs = (0 for i in [0...INDEX_SIZE])
      g2 = (0 for i in [0...INDEX_SIZE])
      if epoch(samples, coeffs, g2, rate, batch_size, dev)
        loss = verify(samples, coeffs)
        if loss < min_loss
          min_loss = loss
          best_rate = rate
        else if best_rate?
          break
      else
        break if best_rate?
      rate /= step_size

    # fine tune
    while step_size >= 1.1
      step_size **= .5
      orig_best = best_rate

      rate = orig_best * step_size
      coeffs = (0 for i in [0...INDEX_SIZE])
      g2 = (0 for i in [0...INDEX_SIZE])
      epoch samples, coeffs, g2, rate, batch_size
      loss = verify(samples, coeffs)
      if loss < min_loss
        min_loss = loss
        best_rate = rate
      else
        rate = orig_best / step_size
        coeffs = (0 for i in [0...INDEX_SIZE])
        g2 = (0 for i in [0...INDEX_SIZE])
        epoch samples, coeffs, g2, rate, batch_size
        loss = verify(samples, coeffs)
        if loss < min_loss
          min_loss = loss
          best_rate = rate

    best_rate

  train = (samples, {quiet}={}) ->
    dev = verify(samples, (0 for i in [0...INDEX_SIZE]))
    console.log "Deviation: #{dev}" unless quiet

    if opt.batch_size?
      batch_size = opt.batch_size
    else
      batch_size = Math.round(samples.length / 10)
      console.log "Batch size: #{batch_size}" unless quiet

    if opt.rate?
      rate = opt.rate
    else
      process.stdout.write 'Finding optimal learning rate: ' unless quiet
      rate = find_rate(samples, batch_size, dev)
      console.log "#{rate}" unless quiet

    coeffs = (0 for i in [0...INDEX_SIZE])
    g2 = (0 for i in [0...INDEX_SIZE])
    min_loss = dev
    for ep in [1..opt.epochs]
      epoch shuffle(samples), coeffs, g2, rate, batch_size
      loss = verify(samples, coeffs)
      if loss < min_loss
        min_loss = loss
        best_coeffs = [coeffs...]
        star = '*'
      else
        star = ''
      console.log "epoch #{ep} loss #{loss} #{star}" unless quiet
    {coeffs: best_coeffs, loss: min_loss, dev}

  cross_validation = (groups, {quiet}={}) ->
    k = groups.length
    avg_loss = 0
    for i in [0...k]
      test_set = groups[i]
      train_set = []
      for j in [0...k]
        train_set = train_set.concat(groups[j]) unless j==i
      console.log "Cross Validation #{i+1}/#{k}" unless quiet
      {coeffs} = train(train_set, quiet: true)

      loss = verify(test_set, coeffs)
      console.log "test set loss: #{loss}" unless quiet
      avg_loss += loss
    avg_loss /= k
    console.log "loss average: #{avg_loss}" unless quiet
    avg_loss

  test_l2 = (groups, l2, min) ->
    process.stdout.write "L2 #{l2}: " if opt.verbose
    opt.l2 = l2
    loss = cross_validation(groups, quiet: true)
    if opt.verbose
      process.stdout.write "loss #{loss}"
      process.stdout.write ' *' if loss < min
      process.stdout.write '\n'
    loss

  search_l2 = (groups) ->
    best = (opt.search_max * opt.search_min) ** .5
    step = (opt.search_max / opt.search_min) ** .25
    min_loss = test_l2(groups, best, Infinity)

    loop
      l2 = best

      tmp = l2 * step
      loss = test_l2(groups, tmp, min_loss)
      if loss < min_loss
        min_loss = loss
        best = tmp
      else
        tmp = l2 / step
        loss = test_l2(groups, tmp, min_loss)
        if loss < min_loss
          min_loss = loss
          best = tmp

      break if step <= opt.search_precision
      step **= 1/2

    console.log "CV search result: #{best}" if opt.verbose
    best

  do ->
    samples = opt.samples or load_samples(opt)

    if opt.cv or opt.search
      groups = split_groups(samples, opt.cv or 4)

    if opt.search
      opt.l2 = search_l2(groups)
      if opt.outfile?
        fs.writeFileSync opt.outfile, "#{opt.l2}\n"
      retval = opt.l2
    else if opt.cv
      retval = cross_validation(groups)
    else
      throw new Error 'outfile is required' unless opt.outfile?

      avg = samples.reduce(((a, s) -> a + s[0]), 0) / samples.length
      console.log "Average: #{avg}" if opt.verbose

      {coeffs, loss, dev, r2} = train(samples, quiet: not opt.verbose)

      r2 = 1 - loss**2 / dev**2
      console.log "r2: #{r2}" if opt.verbose

      retval = {
        coeffs
        avg
        dev
        r2
        loss
        logistic: opt.logistic
        l2: opt.l2
      }
      process.stdout.write "Writing #{opt.outfile}: " if opt.verbose
      fs.writeFileSync opt.outfile, JSON.stringify retval
      console.log "done" if opt.verbose
    retval

module.exports.defaults = defaults
module.exports.load_samples = load_samples
