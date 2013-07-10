###!
scratch
!###

scratch = []

scratch.options = {
  thres: {lo: 3, hi: 10} # path length threshold (anti-aliasing & anti-speeding)
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
    # get bounding rect
    $el = $(el)
    width = $el.outerWidth()
    height = $el.outerHeight()
    {top, left} = offset = $el.offset()

    # make canvas
    # NOTE: must use HTML attr for size (not CSS)
    canvas = $('<canvas class="scratch">')
      .prependTo($el)
      .offset(offset)[0]
    canvas.width = width
    canvas.height = height
    context = canvas.getContext '2d'

    # prevent drag-selecting
    nodrag = (e) -> e.preventDefault()
    el.addEventListener 'mousedown', nodrag, true
    el.addEventListener 'mousemove', nodrag, true

    # initial fill
    context.fillStyle = scratch.options.fillColor
    context.fillRect 0, 0, width, height

    # only reveal content after fill
    $el.children().show()

    # line styling
    context.strokeStyle = '#000' # arbitrary
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
        @iid = setInterval (@draw = =>
          speed = @distance / period
          @distance = 0
          context.globalCompositeOperation = 'destination-out'
          context.lineWidth = 2*getR(speed)
          context.stroke()
        ), period
      path: (p) ->
        if @iid
          {x, y} = p
          @distance += hypot @p0, p
          if @distance > scratch.options.thres.lo then context.lineTo x, y
          if @distance > scratch.options.thres.hi then @draw()
          @p0 = p
      stop: ->
        if @iid
          clearInterval @iid
          @iid = null
          @draw()

      auto: (P) ->
        {x, y} = p = toRel P
        margin = getR(0) * 4
        if -margin < x < width+margin && -margin < y < height+margin
          if @iid then @path p
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
