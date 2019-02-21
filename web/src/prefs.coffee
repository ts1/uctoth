KEY = 'uctoth_prefs'

export prefs = JSON.parse(localStorage[KEY] || '{}')

export set_pref = (key, value) ->
  prefs[key] = value
  localStorage[KEY] = JSON.stringify(prefs)

export get_pref = (key, fallback) -> prefs[key] ? fallback
