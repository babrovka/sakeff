`/** @jsx React.DOM */`
###
data:
  id:
  title:
  started_at:
  state: 'formulated' || 'paused' ||  ...
###

R = React.DOM

@TasksTableRow = React.createClass

  getDefaultProps: ->
    checked: false
    opened: false
    data: {}
    column_names: ['title']
    type: 'root'


  titleClassName: ->
    cx = React.addons.classSet
    result = ''
    result = cx(
      'link-orange' : @.props.data.state == 'formulated',
      'link-success' : @.props.data.state == 'executed',
      'link-default' : @.props.data.state == 'paused',
      'link-asphalt' : @.props.data.state == 'cancelled',
    )
    result += ' link'
    return result



  renderTitle: (obj) ->
    if @.props.type == 'sub'
      [ R.span({className: 'fa fa-level-up text-gray table-subelement'}),
        R.span({}, obj.title)]
    else
      obj.title


  formatData: (col_name) ->
    obj = @.props.data
    data = obj[col_name]

    # если на сервере в БД не записано значение, то приходит в json значение null
    if data != null
      result = data

      # если передана дата в UTC, то преобразуем ее
      _date = new Date(data)
      if !isNaN(_date) && col_name.search(/_at$|deadline/) > -1
        result = moment(_date).format('L')
      else if col_name.search(/title$|name$/) > -1
        result = []
        linkClassName = @.titleClassName()
        _title = @.renderTitle(obj)

        if @.props.type == 'root' && @.props.data.has_subtasks
          className = if @.props.opened then 'fa fa-minus-square-o' else 'fa fa-plus-square-o'
          result.push R.span({className: className, onClick: @.handleQuerySubtasks}, '')
        result.push R.a({href: "/tasks/#{obj.id}", className: linkClassName}, _title)

      else if col_name.search(/user|executor|approver|creator|inspector/) > -1
        title = try
          data.first_name_with_last_name
        catch
          ''
        result = R.a({href: '#', className: 'link link-dashed'}, title)

      else if col_name.search(/state|status/) > -1
        result = TasksTableTaskState({state_title: data, active: obj.has_notification})

      return result


  handleQuerySubtasks: (e) ->
    e.preventDefault()
    @.props.on_opened @.props.data

  handleCheckboxChange: (e) ->
    @.props.on_row_checked @.props.data


  # анимирует элементы при первом рендере, т.е.при каждом открытии
  componentDidMount: ->
    $(@.refs.row.getDOMNode()).velocity('transition.slideDownBigIn', {duration: 100})


  activeRow: (status) ->
    return if status==true
      return 'active'



  render: ->
    render_data = R.tr({ref: 'row', className: @.activeRow(@.props.checked)},
        [
          R.td({}, R.input({type: 'checkbox', checked: @.props.checked, name: "task_#{@.props.data.id}", className: 'js-icheck-off', onChange: @.handleCheckboxChange})),
          @.props.column_names.map((col_name) =>
            R.td({className: col_name}, @.formatData(col_name))
          )
        ]
      )

    render_data
