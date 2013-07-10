###!
boot
!###

$ ->
  await scratch.init defer()
  $('.biaodan_table tr:not(:first-child) > td:last-child:not(:first-child)')
    #.filter(-> !(@innerHTML.match /\*+/))
    .each(-> scratch.make @)
