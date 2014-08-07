$(document).ready ->
  $(".js-left-menu > li").mouseover(->
    $(".js-left-menu-sublinks-bg").addClass "m-left-menu-sublinks-bg-visible"  if $(this).find("ul").length
    return
  ).mouseout ->
    $(".js-left-menu-sublinks-bg").removeClass "m-left-menu-sublinks-bg-visible"
    return
  return
