###!
boot
!###

$ ->
  await scratch.init defer()
  $('.biaodan_table tr:not(:first-child) > td:last-child:not(:first-child)')
    #.filter(-> !(@innerHTML.match /\*+/))
    .each(-> scratch.make @)
  $('.window_neirong > a:nth-child(4) > table:nth-child(2) tr:not(:first-child) > td:nth-child(6)')
    #.filter(-> !(@innerHTML.match /\*+/))
    .each(-> scratch.make @)
