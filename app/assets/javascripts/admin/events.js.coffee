@global ||= {}
@global.params ||= {}

@global.params

$ ->
  $('.js-select2').select2(global.select2)
  $('select.js-select2-nosearch').select2(global.select2_nosearch)


  # раскрывающиеся списки
  # встречаются на странице ролей
  # у строки есть подстроки, которые вначале скрыты,
  # а после действий пользователя они раскрываются
  # родитель и потомок имеют определенные классы
  # связь происходит по полю role-id
  parent_name = '.js-roles-table-role-row'
  parent_action_name = '.js-roles-table-action-btn'
  children_name = '.js-roles-table-permission-row'
  $(children_name).hide()

  $(parent_name).on('click', parent_action_name, (e) ->
    e.preventDefault()
    # переключаем плюс на минус
    $btn = $(e.target).closest(parent_action_name).toggleClass('fa-minus-square', 'fa-plus-square')

    target = $btn.closest(parent_name).data('role-id')
    $(children_name).filter("[data-role-id='#{target}']").toggle()
  )

  $(document).checkboxes_and_radio()

  nestedFormHandler = new app.NestedForm

