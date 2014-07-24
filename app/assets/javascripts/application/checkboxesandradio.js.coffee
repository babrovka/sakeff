$.fn.checkboxesandradio = ->
  inputCheckbox = $(":checkbox")
  inputCheckbox.each ->
    checkbox = $(this)
    if checkbox.attr("disabled") is "disabled"
      if not checkbox.attr("checked") or checkbox.attr("checked") is "false"
        checkbox.parent().prepend "<i class=\"fa disabled fa-square-o\"></i>"
      else
        checkbox.parent().prepend "<i class=\"fa disabled fa-check-square\"></i>"
    else
      checkbox.parent().prepend "<i class=\"fa fa-square-o\"></i>"
    checkbox.attr "hidden", true
    checkbox.on "change", ->
      i = checkbox.prev("i")
      unless checkbox.attr("disabled") is "disabled"
        if not checkbox.attr("checked") or checkbox.attr("checked") is "false"
          i.removeClass "fa-square-o"
          i.addClass "fa-check-square"
          checkbox.attr "checked", true
        else
          i.addClass "fa-square-o"
          i.removeClass "fa-check-square"
          checkbox.attr "checked", false
      return

    return

  $(".form-group").each ->
    radiobutton = $(":radio", $(this))
    radiobutton.each ->
      if ($(this).attr("disabled") is "disabled") and (not $(this).is(":checked"))
        $(this).parent().prepend "<i class=\"fa disabled fa-circle-o\"></i>"
      else if ($(this).attr("disabled") is "disabled") and ($(this).is(":checked"))
        $(this).parent().prepend "<i class=\"fa disabled fa-dot-circle-o\"></i>"
      else if ($(this).attr("disabled") isnt "disabled") and (not $(this).is(":checked"))
        $(this).parent().prepend "<i class=\"fa fa-circle-o\"></i>"
      else $(this).parent().prepend "<i class=\"fa fa-dot-circle-o\"></i>"  if ($(this).attr("disabled") isnt "disabled") and ($(this).is(":checked"))
      radiobutton.attr "hidden", true
      return

    radiobutton.each ->
      $(this).on "change", ->
        i = $(this).prev("i")
        i.removeClass "fa-circle-o"
        i.addClass "fa-dot-circle-o"
        $(this).closest(".form-group").find(":radio").each ->
          $(this).attr "checked", false
          $(this).prev("i").addClass "fa-circle-o"
          $(this).prev("i").removeClass "fa-dot-circle-o"
          return

        $(this).attr "checked", true
        i.addClass "fa-dot-circle-o"
        return

      return

    return

  return