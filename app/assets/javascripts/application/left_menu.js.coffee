$(document).ready ->
  $(".js-left-menu > li").mouseover(->
    $(".js-left-menu-sublinks-bg").addClass "m-left-menu-sublinks-bg-visible"  if $(this).find("ul").length
  ).mouseout ->
    $(".js-left-menu-sublinks-bg").removeClass "m-left-menu-sublinks-bg-visible"

  topOnLoad = $("ul.js-left-menu").offset().top
  $(window).scroll ->
    element = $("ul.js-left-menu")
    if topOnLoad <= $(window).scrollTop()
      element.css
        position: "fixed"
        top: "0"
      $('.js-left-menu-sublinks-bg').css
        position: "fixed"
        top: "0"
    else
      element.css
        position: "absolute"
        top: ""
      $('.js-left-menu-sublinks-bg').css
        position: "absolute"
        top: ""