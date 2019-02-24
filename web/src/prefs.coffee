KEY = 'uctoth_prefs'

prefs = JSON.parse(localStorage[KEY] || '{}')

export set_pref = (key, value) -> set_prefs {key, value}

export get_pref = (key, fallback) -> prefs[key] ? fallback

export get_prefs = -> prefs

export set_prefs = (params) ->
  Object.assign prefs, params
  localStorage[KEY] = JSON.stringify(prefs)
