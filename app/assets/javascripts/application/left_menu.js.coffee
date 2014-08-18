$(document).ready ->
  $(".js-left-menu > li").mouseover(->
    $(".js-left-menu-sublinks-bg").addClass "m-left-menu-sublinks-bg-visible"  if $(this).find("ul").length
    return
  ).mouseout ->
    $(".js-left-menu-sublinks-bg").removeClass "m-left-menu-sublinks-bg-visible"
    return
  return

$(window).scroll ->
  element = $("ul._left-menu")
  if window.app.topOnLoad <= $(window).scrollTop()
    element.css "position", "fixed"
    element.addClass "top0"
    $('.js-left-menu-sublinks-bg').css "position", "fixed"
    $('.js-left-menu-sublinks-bg').addClass "top0"
  else
    element.css "position", "absolute"
    element.removeClass "top0"
    $('.js-left-menu-sublinks-bg').css "position", "absolute"
    $('.js-left-menu-sublinks-bg').removeClass "top0"
  return
