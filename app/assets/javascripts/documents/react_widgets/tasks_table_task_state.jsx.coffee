`/** @jsx React.DOM */`
R = React.DOM

@TasksTableTaskState = React.createClass

  getDefaultProps: ->
    state_title: 'UFO'
    active: false

  getInitialState: (props) ->
    props = props || this.props
    state_title: props.state_title
    active: props.active


  componentWillReceiveProps: (newProps, oldProps) ->
    @.setState(@.getInitialState(newProps))




  translatedName: ->
    I18n.t(@.state.state_title, { scope: 'activerecord.tasks/task.state'})


  className: ->
#    class_name = []
#    class_name.push switch @.state.state_title
#      when 'UFO' then 'label-default'
#      when 'formulated' then 'label-orange '
#      when 'activated' then 'label-blue'
#      when 'paused' then 'label-gray'
#      when 'executed' then 'label-green'
#      when 'cancelled' then 'label-asphalt'

    cx = React.addons.classSet
    result = cx(
      'label-default': @.state.state_title == 'UFO',
      'label-orange': @.state.state_title == 'formulated',
      'label-blue': @.state.state_title == 'activated',
      'label-gray': @.state.state_title == 'paused',
      'label-sea-green': @.state.state_title == 'executed',
      'label-asphalt': @.state.state_title == 'cancelled',
      'm-label-active': @.state.active
      'label': true
    )

    result




  render: ->
    R.span({className: @.className()}, @.translatedName())

