$(document).ready ->
  $(".js-left-menu > li").mouseover(->
    $(".js-left-menu-sublinks-bg").addClass "m-left-menu-sublinks-bg-visible"  if $(this).find("ul").length
  ).mouseout ->
    $(".js-left-menu-sublinks-bg").removeClass "m-left-menu-sublinks-bg-visible"

  topOnLoad = $("ul._left-menu").offset().top
  $(window).scroll ->
    element = $("ul.js-left-menu")
    if topOnLoad <= $(window).scrollTop()
      element.css "position", "fixed"
      element.css "top", 0
      $('.js-left-menu-sublinks-bg').css "position", "fixed"
      $('.js-left-menu-sublinks-bg').css "top", 0
    else
      element.css "position", "absolute"
      element.css "top", ""
      $('.js-left-menu-sublinks-bg').css "position", "absolute"
      $('.js-left-menu-sublinks-bg').css "top", ""