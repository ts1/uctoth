import { get_pref, set_pref } from './prefs'

sounds = {}
context = null

muted = get_pref 'mute', false

AudioContext = window.AudioContext or window.webkitAudioContext

load_sounds = (loader) ->
  sounds.move = loader require './sound/move.mp3'
  sounds.alert = loader require './sound/alert.mp3'
  sounds.undo = loader require './sound/undo.mp3'

if AudioContext?.prototype?.resume?
  init = ->
    return if context
    context = new AudioContext
    context.resume()

    load_sounds (url) ->
      new Promise (resolve, reject) ->
        req = new XMLHttpRequest()
        req.open 'GET', url
        req.responseType = 'arraybuffer'
        req.onload = ->
          if req.status == 200
            context.decodeAudioData req.response, (buffer) -> resolve buffer
          else
            console.dir req
            reject new Error "error loading #{url}"
        req.send()

    window.removeEventListener 'touchstart', init
    window.removeEventListener 'click', init

  window.addEventListener 'touchstart', init
  window.addEventListener 'click', init
else
  load_sounds (url) ->
    el = document.createElement('audio')
    el.src = url
    el.preload = 'auto'
    document.body.appendChild el
    el

export default (name) ->
  return if muted
  if context
    p = sounds[name]
    throw new Error "sound #{name} is not loaded" unless p
    source = context.createBufferSource()
    source.loop = false
    source.buffer = await p
    source.connect context.destination
    source.start 0
  else
    sounds[name].play()

export is_supported = -> true
export is_muted = -> muted
export mute = (mute) ->
  muted = mute
  set_pref 'mute', mute
