start_y = 0
body = document.body

window.addEventListener 'touchmove',
  ((e) ->
    if body.scrollHeight <= window.innerHeight
      e.preventDefault()
  ),
  passive: false
