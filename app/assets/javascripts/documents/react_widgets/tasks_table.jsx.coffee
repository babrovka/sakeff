`/** @jsx React.DOM */`
R = React.DOM

@TasksTable = React.createClass

  getDefaultProps: ->
    url: '/api'
    filter_opts: {}

  getInitialState: ->
    data: []
    search_params: {}

  getDataFromServer: ->
    $.ajax
      url: @props.url
      dataType: "json"
      data:
        q: @.state.search_params
      success: ((data) ->
        data = data['data']
        $(document).trigger('tasks_table:collection:update_data', [data])
        @setState data: data
        return
      ).bind(this)
      error: ((xhr, status, err) ->
        console.error @props.url, status, err.toString()
        return
      ).bind(this)

#  getSubtasksFromServer: (id) ->
#    $.ajax
#      url: "/api/tasks/#{id}/subtasks"
#      dataType: "json"
#      success: ((data) ->
#        subtasks = data['data']
#        $(document).trigger('tasks_table:collection:update_subtasks', [id, subtasks])
#
#        # добавляем новый массив в общий список подзадач
#        new_subtasks = @.state.subtasks
#        new_subtasks.push({ id: id, subtasks: subtasks })
#        @setState subtasks: new_subtasks
#
#        return
#      ).bind(this)
#      error: ((xhr, status, err) ->
#        console.error "/api/tasks/#{id}/subtasks", status, err.toString()
#        return
#      ).bind(this)

  componentWillMount: ->
    @.getDataFromServer()
    $(document).on('tasks_actions:update_success', => @.getDataFromServer())


  onChangeSearchParams: (params) ->
    @.state = search_params: params
    @.getDataFromServer()

#  handleQuerySubtasks: (id) ->
##    console.log id
#    @.getSubtasksFromServer(id)


#  componentWillUpdate: ->
#    $('table tr').velocity('transition.slideDown')


  render: ->
    table_css = 'table new'
    render_data = @.state.data.map( (el) ->
      R.p({}, [
        R.span({}, el.title),
        R.span({}, el.checked),
        R.span({}, el.start_date),
        R.span({}, el.duration),
      ])
    )

    column_names = ['title', 'started_at', 'finished_at', 'executor', 'inspector', 'state']
#    column_names = ['title', 'started_at', 'executor', 'inspector']

    R.table({className: table_css, id: 'table_here'}, [
      TasksTableHeader({column_names: column_names, onChangeFilterParams: @.onChangeSearchParams, filter_opts: @.props.filter_opts}),
      TasksTableList({column_names: column_names, data: @.state.data})
    ])
