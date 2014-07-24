$.fn.checkboxes_and_radio = ->
  inputCheckbox = $(":checkbox")
  inputCheckbox.each ->
    checkbox = $(this)
    if checkbox.attr("disabled") is "disabled"
      if not checkbox.attr("checked") or checkbox.attr("checked") is "false"
        checkbox.parent().prepend "<i class=\"checkbox m-cursor-pointer disabled unchecked\"></i>"
      else
        checkbox.parent().prepend "<i class=\"checkbox m-cursor-pointer disabled checked\"></i>"
    else if not checkbox.attr("checked") or checkbox.attr("checked") is "false"
      checkbox.parent().prepend "<i class=\"checkbox m-cursor-pointer unchecked\"></i>"
    else
      checkbox.parent().prepend "<i class=\"checkbox m-cursor-pointer checked\"></i>"
    checkbox.attr "hidden", true
    checkbox.on "change", ->
      i = checkbox.prev("i")
      unless checkbox.attr("disabled") is "disabled"
        if not checkbox.attr("checked") or checkbox.attr("checked") is "false"
          i.removeClass "unchecked"
          i.addClass "checked"
          checkbox.attr "checked", true
        else
          i.addClass "unchecked"
          i.removeClass "checked"
          checkbox.attr "checked", false
      return

    return

  $(".form-group").each ->
    radiobutton = $(":radio", $(this))
    radiobutton.each ->
      if ($(this).attr("disabled") is "disabled") and (not $(this).is(":checked"))
        $(this).parent().prepend "<i class=\"radiobutton m-cursor-pointer disabled unchecked\"></i>"
      else if ($(this).attr("disabled") is "disabled") and ($(this).is(":checked"))
        $(this).parent().prepend "<i class=\"radiobutton m-cursor-pointer disabled checked\"></i>"
      else if ($(this).attr("disabled") isnt "disabled") and (not $(this).is(":checked"))
        $(this).parent().prepend "<i class=\"radiobutton m-cursor-pointer unchecked\"></i>"
      else $(this).parent().prepend "<i class=\"radiobutton m-cursor-pointer checked\"></i>"  if ($(this).attr("disabled") isnt "disabled") and ($(this).is(":checked"))
      radiobutton.attr "hidden", true
      return

    radiobutton.each ->
      $(this).on "change", ->
        i = $(this).prev("i")
        i.removeClass "unchecked"
        i.addClass "checked"
        $(this).closest(".form-group").find(":radio").each ->
          $(this).attr "checked", false
          $(this).prev("i").addClass "unchecked"
          $(this).prev("i").removeClass "checked"
          return

        $(this).attr "checked", true
        i.addClass "checked"
        i.removeClass "unchecked"
        return

      return

    return

  return