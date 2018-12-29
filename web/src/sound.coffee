sounds = {}
context = null

muted = false

AudioContext = window.AudioContext or window.webkitAudioContext

if AudioContext
  context = new AudioContext

  load = (url) ->
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

  sounds.move = load require './sound/move.mp3'

export default (name) ->
  return unless context
  return if muted
  p = sounds[name]
  throw new Error "sound #{name} is not loaded" unless p
  source = context.createBufferSource()
  source.loop = false
  source.buffer = await p
  source.connect context.destination
  source.start 0

export is_supported = -> context?
export is_muted = -> muted
export mute = (mute) -> muted = mute
