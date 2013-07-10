###!
boot
!###


$ ->
  await scratch.init defer()

  # clear the nasty mouse handlers
  document.oncontextmenu = null
  document.onmousedown = null

  noStars = -> !(@innerHTML.match /\*+/)
  make = -> scratch.make @

  # yxkccj
  $('.biaodan_table tr:not(:first-child) > td:last-child:not(:first-child)')
    #.filter(noStars)
    .each(make)

  # bks_cjdcx
  $('#table1 tr:not(:first-child) > td:nth-child(4)')
    #.filter(noStars)
    .each(make)

  # yjs_cjdcx
  $('.window_neirong > a:nth-child(4) > table:nth-child(2) tr:not(:first-child) > td:nth-child(6)')
    #.filter(noStars)
    .each(make)
