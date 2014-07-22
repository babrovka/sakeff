@global ||= {}
@global.params ||= {}

@global.params.select2 =
  width: 'off'

$ ->
  $('.js-select2').select2(global.params.select2)

  $('select.js-select2-nosearch').select2(
    minimumResultsForSearch: -1
  )


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
    target = $(e.target).closest(parent_name).data('role-id')
    $(children_name).filter("[data-role-id='#{target}']").toggle()
  )

  @

