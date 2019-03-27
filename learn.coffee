fs = require 'fs'
lx = require('bindings')('learn-ext')
{ get_single_index_size, SCORE_MULT } = require './pattern'
{ LOG_MULT } = require './logutil'
Book = require './book'

defaults =
  logistic: false
  verbose: true
  book: 'book.db'
  l2: 0.5
  epochs: 100
  batch_size: null
  k: 4

module.exports = (options) ->
  opt = { defaults..., options... }

  base = if opt.logistic then LOG_MULT else SCORE_MULT
  lx.init get_single_index_size(), opt.logistic, base, opt.verbose

  l2file =
    if opt.l2file == 'auto'
      if opt.logistic
        'l2_logistic.json'
      else
        'l2.json'
    else
      opt.l2file

  l2array =
    if fs.existsSync(l2file)
      console.log "Loading L2 parameter from #{l2file}"
      JSON.parse(fs.readFileSync(l2file))
    else
      null

  load_samples: (phase) ->
    lx.reset()
    book = new Book opt.book, close_on_exit: false
    book.init()
    t = Date.now()
    process.stdout.write "Loading samples for phase #{phase}: " if opt.verbose
    n = 0
    for sample from book.iterate_indexes(phase)
      lx.add_sample sample
      n += 1
    t = Date.now() - t
    console.log "loaded #{n} samples in #{t/1000} seconds" if opt.verbose
    book.close()

  learn: (phase) ->
    l2 = if l2array then l2array[phase] else opt.l2
    console.log "Using L2: #{l2}"
    t = Date.now()
    { weights, loss, avg, dev, offset } =
      lx.learn opt.epochs, l2, opt.batch_size
    r2 = 1 - loss**2 / dev**2
    console.log "R2: #{r2}" if opt.verbose
    t = Date.now() - t
    console.log "Learned in #{t/1000} seconds" if opt.verbose
    { coeffs: weights, r2, loss, avg, dev, offset, l2, logistic: opt.logistic }

  cross_validation: (args) ->
    arg = { opt..., args... }
    loss = lx.cross_validation arg.epochs, arg.l2, arg.batch_size, arg.k

module.exports.defaults = defaults
