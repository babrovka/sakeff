`/** @jsx React.DOM */`

R = React.DOM

@.app.Dialogue = React.createClass

  # Creates empty array for future data
  getInitialState: ->
    {
      dialoguesData: []
    }


  componentDidMount: ->
    $.ajax
      url: this.props.dialoguesPath
      dataType: 'json'
      success: (data) =>
        this.setState({dialoguesData: data})
      error: (xhr, status, err) =>
        console.error(this.props.dialoguesPath, status, err.toString())


  render: ->
    if @.state.dialoguesData.length
      DialogueTable(dialoguesData: this.state.dialoguesData)
    else
      R.h2({}, "Здесь будут показаны диалоги...")


  # Whole table
  DialogueTable = React.createClass
    render: ->
      R.section(
        {className: "table table--dialogues"},
        [
          DialoguesHeader(),
          @.props.dialoguesData.map (dialogue) ->
            Dialogue(dialogue: dialogue)
        ]
      )


  # Heading with titles
  DialoguesHeader = React.createClass
    render: ->
      titles = ["", "Название", "Сообщений всего", "Непрочитанных", "Последнее сообщение", "Время"]
      R.header(
        {className: "thead table__header"},
        R.div({className: "tr table__header__row"},
          [
            titles.map (title) ->
              R.div({className: "th table__header__cell"},
                title
              )
          ]
        )
      )


  # Dialogue row
  Dialogue = React.createClass
    render: ->
      R.div(
        {className: "tr dialogue"},
        [
          R.div({className: "td dialogue__cell dialogue__cell--image"},
            @.props.dialogue.icon_html),
          R.div({className: "td dialogue__cell dialogue__cell--text"},
            @.props.dialogue.link_html),
          R.div({className: "td dialogue__cell dialogue__cell--text"},
            @.props.dialogue.messages_count),
          R.div({className: "td dialogue__cell dialogue__cell--text"},
            @.props.dialogue.unread),
          R.div({className: "td dialogue__cell dialogue__cell--text"},
            @.props.dialogue.last_message),
          R.div({className: "td dialogue__cell dialogue__cell--text"},
            @.props.dialogue.time),
        ]
      )
