`/** @jsx React.DOM */`
R = React.DOM

@TasksActionButtons = React.createClass

  getDefaultProps: ->
    url: ''
    actions: []


  getInitialState: ->
    active_btns: []
    data: {
      actions: []
      ids: []
    }


  # класс иконки в зависимости от события,которое совершает кнопка
  iconClassByAction: (action) ->
    cx = React.addons.classSet
    css_class = cx(
      'fa-bolt': action == 'start'
      'fa-pause': action == 'pause'
      'fa-play': action == 'resume'
      'fa-check-square': action == 'finish'
      'fa-rotate-right': action == 'reformulate'
      'fa-times': action == 'cancel'
      'fa btn btn-default': true
      'js-tooltip': true
    )
    return css_class
    
    
  tooltipTitleByAction: (action) ->
    cx = React.addons.classSet
    title = cx(
      'Приступить': action == 'start'
      'Приостановить': action == 'pause'
      'Продолжить': action == 'resume'
      'Завершить': action == 'finish'
      'Переформулировать': action == 'reformulate'
      'Отменить': action == 'cancel'
    )
    return title

  # обработка клика на кнопке
  # отправляем запрос на сервер
  handleClick: (e) ->
    e.preventDefault()
    action = e.target.dataset['action']
    $.ajax
      type: 'POST'
      url: @.props.url
      data:
        task_ids: @.state.data.ids
        event: action
      success: (responce) ->
        $(document).trigger('tasks_actions:update_success')
      error: (responce) ->
        console.log responce


  # обрабатываем данные,которые пришли
  # находим общие действия над коллекцией
  # выделяем список id коллекции
  handleCheckedData: (checked) ->
    # получаем массив массивов действий [ [1,2], [2,3], [1,2], ...]
    _actions = checked.map((el) -> el.actions )

    # блок выделения общих действий среди массива массивов
    result = _actions[0]
    _others = _actions.slice(1)
    if _others.length
      _.each(_others, (el) ->
        result = _.intersection(_.flatten(result), _.flatten(el));
      )

    data_actions = result
    data_ids = checked.map((el) -> el.id)

    new_data =
      actions: data_actions
      ids: data_ids

    @.setState(data: new_data)

  componentDidMount: ->
    $(document).on('tasks_table:collection:change_checked', (e, checked) =>
      @.handleCheckedData(checked)
    )

  componentDidUpdate: ->
#    console.log $('.js-tooltip').tooltip(placement: 'top')

  render_single_btn: (action) ->
    # свойства для активной кнопки
    opts = {href: '#', className: @.iconClassByAction(action.name), 'data-action': action.name, title: @.tooltipTitleByAction(action.name), onClick: @.handleClick}

    # корректируем свойства для неактивной кнопки
    if @.state.data.actions == undefined || @.state.data.actions.indexOf(action.name) < 0
      new_css_class = opts.className + ' disabled'
      opts = _.extend(opts, {onClick: null, className: new_css_class})

    R.a(opts, '')

  render: ->
    action_btns = @.props.actions.map((action) =>
      @.render_single_btn(action)
    )
    R.div({}, action_btns)