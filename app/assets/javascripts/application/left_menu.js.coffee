$(document).ready ->
  $("ul.js-left-menu li").each ->
    $(this).mouseover ->
      $(".js-left-menu-sublinks-bg").addClass "m-left-menu-sublinks-bg-visible"  if ($(this).find("ul").length is 1) is true
      return
    $(this).mouseout ->
      $(".js-left-menu-sublinks-bg").removeClass "m-left-menu-sublinks-bg-visible"
      return
    return
  return