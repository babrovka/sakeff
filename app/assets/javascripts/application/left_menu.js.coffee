$(document).ready ->
  $("ul.js-left-menu > li").on('click', ->
    $(this).find("ul").slideDown()
    $(this).addClass "selected"
    $(this).siblings().removeClass "selected"
    $(this).siblings().find("ul").slideUp())
  $("ul.js-left-menu li a[href='#']").on('click', (e) ->
    e.preventDefault()
  )

#    $("ul li a", $(this)).each ->
#      $(this).click ->
#        $(this).addClass "selected"
#        $(this).parent().siblings().find("a").removeClass "selected" - script для презентации

  topOnLoad = $("ul.js-left-menu").offset().top
  $(window).scroll ->
    element = $("ul.js-left-menu")
    if topOnLoad <= $(window).scrollTop()
      element.css
        position: "fixed"
        top: "0"
        left: -($(window).scrollLeft())+'px'
        marginTop: 0
      $('.js-left-menu-sublinks-bg').css
        position: "fixed"
        top: 0
    else
      element.css
        position: "absolute"
        top: ""
        left: 0
        marginTop: -6+'px'
      $('.js-left-menu-sublinks-bg').css
        position: "absolute"
        top: ""
    $('.server-title').css('left', $(window).scrollLeft()+'px')