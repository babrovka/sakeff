`/** @jsx React.DOM */`
R = React.DOM

@TasksAddSubtask = React.createClass
  getDefaultProps: ->
    opened: false


  getInitialState: (props) ->
    props = props || this.props
    {liked: props.opened}

  handleClick: ->
    console.log 'click'

    this.setState({opened: !this.state.opened});

  translatedName: ->
    I18n.t(@.state.state_title, { scope: 'activerecord.tasks/task.state'})



  render: ->
    status = 'btn ' +
    (if this.state.opened
      'opened'
    else 'closed')

    popover_status = 'popover ' +
    (if this.state.opened
      ''
    else 'hidden')

    popoverBody = R.div({className:'inner'}, [
      R.input({className: 'name', type: 'text', name: 'title', placeholder: 'Название'}),
      R.select({className: 'executor', name: 'executor', type: 'text', placeholder: 'Исполнитель'}, [R.option({}),R.option({}, 'Опция1'),R.option({}, 'Опция2')]),
      R.input({className: 'started_at', type: 'text', name: 'started_at', placeholder: 'Дата начала'}),
      R.input({className: 'started_at', type: 'text', name: 'finished_at', placeholder: 'Дата конца'}),

    ])

    button = R.span({className: status, onClick: @handleClick}, 'Добавить подзадачу')
    popover = R.div({className: popover_status}, popoverBody)
    R.div(className: ' ', [button, popover])