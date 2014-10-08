# Плагин обрабатывает все простые инпуты типа "чекбокс" (<input type="checkbox" />) и группы радио- кнопок (<input type="radiobutton" />),
# объединенных контейнером с классом ".form-group", проставляя вместо стандартных инпутов, графические реализованные с помощью Font Awesome.
# При этом наличие состояния checked="checked" передается в стандартный инпут в зависимости от изменения статуса инпута.
# Состояние disabled="disabled" отслеживается при загрузке html-документа и передается стандартному инпуту.
# Состояние по-умолчанию также отслеживается при загрузке html-документа и передается инпуту в не зависимости от того активен он или нет.
#
# У радио- кнопок помимо стандартного простого случая (группа активных радио- кнопок, одна из них имеет состояние checked) предусмотрены
# еще следующие случаи:
# 1. В группе радио- кнопок имеется одна или несколько кнопок в неактивном состоянии, но имеющая при этом состояние checked.
# В данном случае при клике на любую активную кнопку из данной группы, этой кнопке проставляется состояние checked. Неактивная кнопка при этом теряет статус checked.
# 2. Один или несколько радио- кнопок по умолчанию имеют статус checked. В этом случае, согласно стандартам w3 - http://www.w3.org/TR/html401/interact/forms.html#radio
# видимое состояние checked принимает кнопка с состоянием checked идущая последней в данной группе. При клике на любую активную радио- кнопку из группы
# все остальные кнопки, в не зависимости от состояния активности, теряют состояние checked.


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

    # Mimics tab behaviour
    checkbox.addClass("moved-away")
    checkbox.on "focus", ->
      $(@).parent().addClass("checkbox--focused")
    checkbox.on "focusout", ->
      $(@).parent().removeClass("checkbox--focused")

    checkbox.on "change", ->
      i = checkbox.siblings("i")
      if checkbox.attr("disabled") isnt "disabled"
        if not checkbox.attr("checked") or checkbox.attr("checked") is "false"
          i.removeClass "unchecked"
          i.addClass "checked"
          checkbox.attr "checked", true
        else
          i.addClass "unchecked"
          i.removeClass "checked"
          checkbox.attr "checked", false
      else
        if not checkbox.attr("checked") or checkbox.attr("checked") is "false"
          i.removeClass "unchecked"
          i.addClass "checked"
          checkbox.attr "checked", true
        else
          i.addClass "unchecked"
          i.removeClass "checked"
          checkbox.attr "checked", false

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
        i = $(this).siblings("i")
        i.removeClass "unchecked"
        i.addClass "checked"
        $(this).closest(".form-group").find(":radio").each ->
          $(this).attr "checked", false
          $(this).siblings("i").addClass "unchecked"
          $(this).siblings("i").removeClass "checked"
          return

        $(this).attr "checked", true
        i.addClass "checked"
        i.removeClass "unchecked"
        return

      return

    return

  return

