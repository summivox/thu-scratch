getR = (speed) -> 10 # TODO: variable radius

makeScratch = (el) ->
  $el = $(el)
  width = $el.innerWidth()
  height = $el.innerHeight()
  {top, left} = $el.offset()

  # make canvas
  $cover = $('<canvas class="scratch-cover">').appendTo(el)
  cover = $cover[0]
  cover.width = width # must not use CSS
  cover.height = height
  context = cover.getContext '2d'

  # initial fill
  context.fillStyle = '#666'
  context.fillRect 0, 0, width, height

  # clear to given point
  clearTo = do ->
    clearTo = (p0) ->
      {x, y} = p0
      context.strokeStyle
      p2 = p1
      p1 = p0



# apply to all
$ -> $('.scratch').each -> makeScratch @
