###!
boot
!###

$ ->
  $all = $('.biaodan_table tr:not(:first-child) > td:last-child:not(:first-child)').addClass('scratch')
  await scratch.init defer()
  $all.each(-> scratch.make @)
