# Keep ext.js (output of emscripten) separated and load with importScripts
# inside try-catch.
# Otherwise, if we bundle it, the entire JS is aborted on environments where
# WebAssembly is not available.
try
  importScripts 'ext.js'
  ext_loaded = true
catch
  ext_loaded = false
  self.Module = cwrap: -> # dummy

import { N_PHASES } from '../pattern'
import { int } from '../util'

export is_enabled = false

export set_verbose = Module.cwrap 'set_verbose', null, ['boolean']

_uct_search = Module.cwrap 'uct_search', 'number',
  ['string', 'number', 'number', 'number']

export uct_search = (board, turn, n_search, scope) ->
  retval = _uct_search(board, turn, n_search, int(scope))
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

export set_weights = (weights) ->
  for i in [0...N_PHASES]
    ptr = _get_weights_ptr(i)
    array = new Uint8Array weights[i].buffer
    Module.writeArrayToMemory array, ptr
    ###
    console.log 'setting weight', i
    _set_weights_single i, new Uint8Array weights[i].buffer
    ###
  return

export ready = new Promise (resolve, reject) ->
  if ext_loaded
    Module.onRuntimeInitialized = ->
      is_enabled = true
      resolve()
    Module.onAbort = -> reject()
  else
    reject()
