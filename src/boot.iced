###!
boot
!###


$ ->
  await scratch.init defer()

  # clear the nasty mouse handlers
  document.oncontextmenu = null
  document.onmousedown = null

  noStars = -> !(@innerHTML.match /\*+/)
  fancyScore = ->
    @style.textAlign = 'center'
    s = @innerHTML.toString().trim()
    switch
      when s.match /\*+/
        @innerHTML = '谢谢惠顾'
      when s.match /[\d\.]+/
        i = parseFloat s
        if i < 60
          @innerHTML = """<a title="#{i}" style="color:#f00;cursor:default;">再考一次</a>"""
  make = -> scratch.make @

  # yxkccj
  $('.biaodan_table tr:not(:first-child) > td:last-child:not(:first-child)')
    #.filter(noStars)
    .each(fancyScore)
    .each(make)

  # bks_cjdcx
  $('#table1 tr:not(:first-child) > td:nth-child(4)')
    #.filter(noStars)
    .each(fancyScore)
    .each(make)

  # yjs_cjdcx
  $('.window_neirong > a:nth-child(4) > table:nth-child(2) tr:not(:first-child) > td:nth-child(6)')
    #.filter(noStars)
    .each(fancyScore)
    .each(make)
