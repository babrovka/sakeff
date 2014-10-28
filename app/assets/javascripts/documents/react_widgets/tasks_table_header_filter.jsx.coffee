`/** @jsx React.DOM */`
R = React.DOM

@TasksTableHeaderFilter = React.createClass

  popover_nested_name: ''

  getDefaultProps: ->
    name: ''
    data: []
    filter_opts: {}
    filter_popover_opened: false

  getInitialState: (props) ->
    props = props || this.props
    data: props.data
    filter_popover_opened: props.filter_popover_opened


  # пробрасываем параметры из всплывающего окна наверх по цепочке зависимостей
  onChangeFilterParams: (params) ->
    @.props.onChangeFilterParams(
      params
    )


  handlePopoverToggle: (current_popover_state) ->
    @.setState filter_popover_opened: current_popover_state


  componentWillReceiveProps: (newProps, oldProps) ->
    @.setState(@.getInitialState(newProps))


  handleClick: (e) ->
    e.preventDefault()


  componentDidMount: ->
    $el = $('<div></div>').appendTo('.js-popover-layout')

    @.popover_nested_name = "js-tasks-table-filter-popover-#{(new Date()).getTime()}"
    popover_nested_name_class_name = ".#{@.popover_nested_name}"
#    console.log @.props.filter_opts[@.props.name]
    filter_component_params = {
      parent: popover_nested_name_class_name,
      opened: @.state.filter_popover_opened,
      onPopoverSubmit: @.onChangeFilterParams,
      onPopoverToggle: @.handlePopoverToggle,
      filter_opts: @.props.filter_opts[@.props.name],
      placement: 'bottom'
    }

    popoverClassName = @.choosePopoverRenderer()
    if _.isFunction(popoverClassName)
      React.renderComponent(popoverClassName(filter_component_params), $el[0])


  choosePopoverRenderer: ->
    if @.props.name == 'title'
      TasksTableHeaderFilterPopoverTitleBeta
    else if @.props.name == 'started_at' || @.props.name == 'finished_at'
      TasksTableHeaderFilterPopoverStartedAtBeta
    else if @.props.name == 'executor' || @.props.name == 'inspector'
      TasksTableHeaderFilterPopoverUsersBeta



  render: ->
    cx = React.addons.classSet
    icon_css = cx(
      'm-active': @.state.filter_popover_opened == true
      'fa fa-filter': true
    )

    icon_css += " #{@.popover_nested_name}"



    filter_dom = if ['title', 'started_at', 'finished_at', 'executor', 'inspector'].indexOf(@.props.name) > -1
      [R.span({onClick: @.handleClick, className: icon_css})]

    R.span({className: 'table-filter'}, filter_dom)
