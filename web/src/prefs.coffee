KEY = 'uctoth_prefs'

prefs = JSON.parse(localStorage[KEY] || '{}')

export set_pref = (key, value) ->
  prefs[key] = value
  set_prefs()

export get_pref = (key, fallback) -> prefs[key] ? fallback

export get_prefs = -> prefs

export set_prefs = (params) ->
  prefs = { prefs..., params... } if params?
  localStorage[KEY] = JSON.stringify(prefs)
