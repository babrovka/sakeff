$(document).ready ->
  $("ul.js-left-menu > li").each ->
    $(this).click ->
      $(this).find("ul").slideDown()
      $(this).addClass "selected"
      $(this).siblings().removeClass "selected"
      $(this).siblings().find("ul").slideUp()

    $("ul li a", $(this)).each ->
      $(this).click ->
        $(this).addClass "selected"
        $(this).parent().siblings().find("a").removeClass "selected"

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