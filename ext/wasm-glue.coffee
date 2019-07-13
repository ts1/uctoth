# Keep ext.js (output of emscripten) separated and load with importScripts
# inside try-catch.
# Otherwise, if we bundle it, the entire JS is aborted on environments where
# WebAssembly is not available.
if 0 # XXX WASM is currently broken
  try
    importScripts 'ext.js'
    ext_loaded = true
  catch
else
  ext_loaded = false
  self.Module = cwrap: -> # dummy

import { N_PHASES } from '../pattern'
import { int } from '../util'

export is_enabled = false

export set_verbose = Module.cwrap 'set_verbose', null, ['boolean']

_set_uct_options = Module.cwrap 'set_uct_options', null,
  ['number', 'number', 'number', 'boolean',  'boolean']

export set_uct_options = (n_search, scope, randomness, tenacious, by_value) ->
  _set_uct_options n_search, scope, randomness, tenacious, by_value

_uct_search = Module.cwrap 'uct_search', 'number',
  ['string', 'number', 'number', 'number']

export uct_search = (board, turn, mask_upper, mask_lower) ->
  retval = _uct_search(board, turn, mask_upper, mask_lower)
  value = retval >> 8
  move = retval & 0xff
  { move, value }

export evaluate = Module.cwrap 'eval', 'number', ['string', 'number']

_solve = Module.cwrap 'solve', 'number', ['string', 'number', 'number']

export solve = (board, turn, wld) ->
  retval = _solve(board, turn, wld)
  value = retval >> 16
  move = retval & 0xff
  { move, value, solved: if wld then 'wld' else 'full' }

_set_weights_single = Module.cwrap 'set_weights_single', null,
  ['number', 'array']
_get_weights_ptr = Module.cwrap 'get_weights_ptr', 'number', ['number']
_nega_weight = Module.cwrap 'nega_weight', null, []

export set_weights = (weights, inverted) ->
  for i in [0...N_PHASES]
    ptr = _get_weights_ptr(i)
    array = new Uint8Array weights[i].buffer
    Module.writeArrayToMemory array, ptr
  _nega_weight() if inverted
  return

export ready = new Promise (resolve, reject) ->
  if ext_loaded
    Module.onRuntimeInitialized = ->
      is_enabled = true
      resolve()
    Module.onAbort = -> reject()
  else
    reject()
