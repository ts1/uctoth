{ set_pref } = require './prefs'

set_pref 'lang', location.href.split('/').slice(-1)[0].split('.')[0]

require './main'
