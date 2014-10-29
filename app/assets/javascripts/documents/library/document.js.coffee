#window.app.documents =
#  selected_actions: []
#  actions_by_rows: (checkbox) ->
#    current_actions = $(checkbox).parents('tr').data('server-actions')
#    result = []
#    # if checked
#    if $(checkbox).is(":checked")
#      unless app.documents.selected_actions.length > 0
#        app.documents.selected_actions = _.intersection(current_actions)
#      else
#        app.documents.selected_actions = _.intersection(app.documents.selected_actions, current_actions)
#      result = app.documents.selected_actions
#    else
#      all_checkboxes = $(checkbox).parents('table').find('.js-row-select').filter(':checked')
#
#      _selected_actions = []
#      _.each(all_checkboxes, (checkbox) ->
#        actions = $(checkbox).parents('tr').data('server-actions')
#        unless _selected_actions.length > 0
#          _selected_actions = _.intersection(actions)
#        else
#          _selected_actions = _.intersection(_selected_actions, actions)
#      )
#      result = _selected_actions
#
#    result
#
#  render_actions_list: (actions) ->
#    $list = $('.js-documents-actions-list')
#    $list.empty()
#    console.log actions
#    out = []
#    if actions.length > 0
#      _.each(actions, (action) ->
#        link = switch action
#          when 'edit' then window.app.documents.render_edit_link()
#          when 'reply' then window.app.documents.render_reply_link()
#          else window.app.documents.render_change_state_link(action)
#
#        out.push(link)
#      )
#    else
#      out.push('<li>выберите документы</li>')
#
#    $list.html out.join('')
#
#  render_edit_link: ->
#    $el = $('table .js-row-select:checked')
#    if $el.length == 1
#      id = $el.parents('tr').data('id')
#      "<li><a href='/documents/#{id}/edit'>редактировать</a></li>"
#    else
#      null
#
#
#  render_reply_link: ->
#    $el = $('table .js-row-select:checked')
#    if $el.length == 1
#      id = $el.parents('tr').data('accountable-id')
#      "<li><a href='/documents/mails/#{id}/reply'>ответить</a></li>"
#    else
#      null
#
#  render_change_state_link: (action)->
#    $els = $('table .js-row-select:checked')
#    if $els.length > 0
#      ids = []
#      _.each($els, (el) ->
#        id = $(el).parents('tr').data('id')
#        console.log id
#        ids.push(id)
#      )
#      console.log ids
#      _ids = ids.join(',')
#
#      action_name = switch action
#                      when 'draft' then 'в черновики'
#                      when 'prepared' then 'подготовлены'
#                      when 'approved' then 'подтвердить'
#                      when 'sent' then 'отправить'
#                      when 'read' then 'прочесть'
#                      when 'trashed' then 'удалить'
#                      when 'accepted' then 'принять'
#                      when 'rejected' then 'возвратить'
#                      else 'не известное действие'
#      "<li><a href='/documents/batch?document_ids[]=#{_ids}&state=#{action}'>#{action_name}</a></li>"
#    else
#      null



$ ->
#  # select checkboxes to select tables rows and update 'actions' UIcontrol.
#  # in each rows saves actions for it document.
#  # if select several rows, than filtering it actions to same.
#  $(".js-row-select").on('ifChanged', ->
#    actions = app.documents.actions_by_rows(@)
#    app.documents.render_actions_list(actions)
#  )
#  $(".js-select-all-in-table").on('ifChanged', ->
#    $(".js-row-select").iCheck('toggle');
#
##    actions = app.documents.actions_by_rows(@)
##    app.documents.render_actions_list(actions)
#  )
#
#
#  # checkbox active/disable custom input
#  # Important! Next event will works with iCheck plugin.
#  $('.js-active-input').on('ifChanged change', ->
#    $el = $(@)
#    target = $el.data('target')
#    $target = $('body').find("[data-target='#{target}']").not('.js-active-input')
#    $target.prop('disabled', !$target.prop('disabled')).trigger('chosen:updated')
#  )
#
#  # styling attachment file fields
#  $(document).on('nested:fieldAdded', (e) ->
#    $field = $(e.field).find('input[type=file]')
#    $field.wrap('<div class="col-sm-offset-2 col-sm-5"></div>')
#    $field.filestyle()
#  )