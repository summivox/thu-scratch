###!
scratch
!###

scratch = []

scratch.options = {
  fps: 30 # redraw frequency
  r0: 6 # base radius (px)
  fillColor: '#666'
}

scratch.make = do ->
  getR = -> scratch.options.r0 # TODO: variable (need better drawing method)
  hypot = (p1, p2) ->
    {x: x1, y: y1} = p1
    {x: x2, y: y2} = p2
    dx = x2 - x1
    dy = y2 - y1
    Math.sqrt(dx*dx + dy*dy)

  make = (el) ->
    el.classList.add 'scratch'

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

    # the scratch object
    o = {
      canvas
      context
      iid: null
      start: (p0) ->
        period = 1000 / scratch.options.fps
        context.beginPath()
        @p0 = p0
        @distance = 0 # for deriving speed
        @iid = setInterval (@handler = =>
          speed = @distance / period
          @distance = 0
          context.globalCompositeOperation = 'destination-out'
          context.lineWidth = 2*getR(speed)
          context.stroke()
        ), period
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
    
    this.push o
    return o # scratch.make

scratch.init = do ->
  isMouseDown = false
  autoAll = (e) ->
    P = {x: e.pageX, y: e.pageY}
    scratch.forEach (sc) -> sc.auto P

  init = (autocb) ->
    # add styling
    $("<style>#{PACKED_CSS['scratch.css']}</style>").appendTo('head')

    $(document).mousedown (e) ->
      isMouseDown = true
      autoAll e
    $(document).mousemove (e) ->
      if isMouseDown then autoAll e
    $(document).mouseup (e) ->
      isMouseDown = false
      scratch.forEach (sc) -> sc.stop()
