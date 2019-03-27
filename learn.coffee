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

  learn: (args) ->
    t = Date.now()
    arg = { opt..., args... }
    { weights, loss, avg, dev, offset } =
      lx.learn arg.epochs, arg.l2, arg.batch_size
    r2 = 1 - loss**2 / dev**2
    console.log "R2: #{r2}" if arg.verbose
    t = Date.now() - t
    console.log "Learned in #{t/1000} seconds" if opt.verbose
    { coeffs: weights, r2, loss, avg, dev, offset, l2: arg.l2 }

  cross_validation: (args) ->
    arg = { opt..., args... }
    loss = lx.cross_validation arg.epochs, arg.l2, arg.batch_size, arg.k

module.exports.defaults = defaults
