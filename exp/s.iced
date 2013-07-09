FPS = 30
PERIOD = 1000/FPS

# radius from speed
r0 = 6
#speed0 = 0.7
#getR = (speed) ->
  #r = r0 * Math.exp(-speed/speed0)
  #console.log "v=#{speed}, r=#{r}"
  #r
getR = -> r0

hypot = (p1, p2) ->
  {x: x1, y: y1} = p1
  {x: x2, y: y2} = p2
  dx = x2 - x1
  dy = y2 - y1
  Math.sqrt(dx*dx + dy*dy)


makeScratch = (el) ->
  $el = $(el)
  width = $el.innerWidth()
  height = $el.innerHeight()
  {top, left} = $el.offset()

  # make canvas
  # NOTE: must use HTML attr for size (not CSS)
  $canvas = $('<canvas class="scratch-cover">').prependTo(el)
  canvas = $canvas[0]
  canvas.width = width
  canvas.height = height
  context = canvas.getContext '2d'

  # initial fill
  context.fillStyle = '#666'
  context.fillRect 0, 0, width, height

  # only reveal content after fill
  $el.children().show()

  # line styling
  context.strokeStyle = '#000'
  context.lineCap = 'butt'
  context.lineJoin = 'round'

  toRel = (P) ->
    x = P.x - left
    y = P.y - top
    {x, y}

  # return drawing object
  {
    canvas
    context
    iid: null
    start: (p0) ->
      context.beginPath()
      @p0 = p0
      @distance = 0 # for deriving speed
      @iid = setInterval (@handler = =>
        speed = @distance / PERIOD
        @distance = 0
        context.globalCompositeOperation = 'destination-out'
        context.lineWidth = 2*getR(speed)
        context.stroke()
      ), PERIOD
    draw: (p) ->
      if @iid
        {x, y} = p
        @distance += hypot @p0, p
        context.lineTo x, y
        @p0 = p
    stop: ->
      if @iid
        clearInterval @iid
        @iid = null
    
    auto: (P) ->
      {x, y} = p = toRel P
      margin = getR(0) * 4
      if -margin < x < width+margin && -margin < y < height+margin
        if @iid then @draw p
        else @start p
      else @stop()
  }

isScratch = (el) ->
  el instanceof HTMLCanvasElement && el.classList.contains 'scratch-cover'

$ ->
  window.scratches = $('.scratch').map(-> makeScratch @).toArray()
  autoAll = (e) ->
    P = {x: e.pageX, y: e.pageY}
    window.scratches.forEach (sc) -> sc.auto P

  isDown = false
  $(document).mousedown (e) ->
    isDown = true
    autoAll e
  $(document).mousemove (e) ->
    if isDown then autoAll e
  $(document).mouseup (e) ->
    isDown = false
    window.scratches.forEach (sc) -> sc.stop()
