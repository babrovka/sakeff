`/** @jsx React.DOM */`
R = React.DOM

@TasksTableList = React.createClass

  getDefaultProps: ->
    data: []
    column_names: ['title']



  getInitialState: ->
    data: []
    checked_all: false


  handleRowCheck: (obj) ->
    # копируем коллекцию и работаем с копией,
    # обновляя в ней атрибуты нужных нам объектов
    new_data = @.state.data
    if obj.hasOwnProperty('parent_id')
      data_pos = if obj.parent_id < 1 then 'null' else obj.parent_id
      try
        finded_obj = _.findWhere(new_data[data_pos], {id: obj.id})
        finded_obj_pos = new_data[data_pos].indexOf(finded_obj)
        new_data[data_pos][finded_obj_pos].checked = !obj.checked


    @.changeCheckedRows(new_data)
    @.setState data: new_data
    window.app.GanttView.updateSelectTask(finded_obj.id, obj.checked)

  # метод создания ивента с чекнутыми задачами
  # фильтрует задачи только сортированными
  # в событии передает коллекцию чекнутых объектов
  changeCheckedRows: (data) ->
    # фильтруем только те задачи, которые имеют checked: true
    checked_data = _.where(_.flatten(_.values(data)), {checked: true})
    $(document).trigger('tasks_table:collection:change_checked', [checked_data])
    checked_data




  # обрабатываем выделение всех строк
  # обрабатываем копию данных
  # бросаем событие «строки чекнуты»
  # меняем статус,что приводит к перерисовке
  checkAllRows: ->
    keys = _.keys(@.state.data)
    new_data = {}
    _.each(keys, (key) =>
      new_data[key] =
        _.map(@.state.data[key], (obj) =>

          obj.checked = !@.state.checked_all
          obj
      )
    )


    @.changeCheckedRows(new_data)

    @.setState
      data: new_data
      checked_all: !@.state.checked_all

  uncheckAllRows: ->
    keys = _.keys(@.state.data)
    new_data = {}
    _.each(keys, (key) =>
      new_data[key] =
        _.map(@.state.data[key], (obj) =>

          obj.checked = false
          obj
      )
    )


    @.changeCheckedRows(new_data)

    @.setState
      data: new_data
      checked_all: @.state.checked_all



  componentDidMount: ->
    $(document).on('tasks_table:collection:check_all', (e) =>
      @.checkAllRows()
    )
#  componentDidMount: ->
    $(document).on('tasks_table:collection:uncheck_all', (e) =>
      @.uncheckAllRows()
    )

  # сортируем пришедшую коллекцию по родителям-предкам
  componentWillReceiveProps: (newProps, oldProps) ->
    data = newProps.data
    window.arr = @.state.data = _.groupBy(data, (obj) ->
      obj.parent_id
    )

    @.setState data: @.state.data



  # рисует строку с задачей и рекурсивно вызывает отрисовку подзадач
  render_task_with_subtasks: (obj, is_subtasks=false) ->
    subtasks = if @.state.data.hasOwnProperty(obj.id) && obj.opened then @.state.data[obj.id] else []
    type = if is_subtasks then 'sub' else 'root'
    opts =
      column_names: @.props.column_names
      data: obj
      checked: obj.checked
      opened: obj.opened
      type: type
      on_row_checked: @.handleRowCheck,
      on_opened: @.handleQuerySubtasks
    [
      TasksTableRow(opts),
      subtasks.map((sub_el) =>
        @.render_task_with_subtasks(sub_el, true)
      )
    ]

  # обрабатываем запрос на отображение подзадач
  handleQuerySubtasks: (obj) ->
    new_data = @.state.data
    if obj.hasOwnProperty('parent_id')
      data_pos = if obj.parent_id < 1 then 'null' else obj.parent_id
      try
        finded_obj = _.findWhere(new_data[data_pos], {id: obj.id})
        finded_obj_pos = new_data[data_pos].indexOf(finded_obj)
        new_data[data_pos][finded_obj_pos].opened = !obj.opened
        updated_obj = new_data[data_pos][finded_obj_pos]
      catch
        console.error 'error in finding obj in data array'

    # бросить ивент с id-родительской-задачи и [id, id]-потомков
    obj_id = updated_obj.id
    children_ids = @.state.data[updated_obj.id]
    is_opened = updated_obj.opened
    $(document).trigger('tasks_table:collection:update_subtasks', [obj_id, children_ids, is_opened])
    @.setState data: new_data




  render: ->
    collection = []
    unless _.keys(@.state.data).length
      rows = R.tr({}, R.td({colSpan: @.props.column_names.length},'Данные загружаются...'))
    else
      try
        # проверка на наличие рутовых и подзадач
        if @.state.data.hasOwnProperty('null')
          collection = @.state.data['null']
        else
         collection = _.flatten(_.values(@.state.data))

        rows = collection.map((obj) =>
          @.render_task_with_subtasks(obj)
        )

      catch
        rows = R.tr({}, R.td({colSpan: @.props.column_names.length}, 'Ошибка в пришедших данных. Невозможно составить список задач...'))

    R.tbody({ref: 'task_rows'}, rows)


###

  obj:{
    id: 5
    data: {}
    checked: true
  }

  obj = _.findWhere(arr, {id: 5})
  i = arr.indexOf(obj)
  obj[i].checked = true

###

