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
        {className: "block-table block-table--dialogues"},
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
        {className: "block-table__thead"},
        R.div({className: "block-table__tr"},
          [
            titles.map (title) ->
              R.div({className: "block-table__th"},
                title
              )
          ]
        )
      )


  # Dialogue row
  Dialogue = React.createClass
    render: ->
      iconClass = "m-#{parseInt(@.props.dialogue.receiver_id).toString()[0]}"
      messagesWord = window.app.Pluralizer.pluralizeString(@.props.dialogue.messages_count, "сообщение","сообщения","сообщений")

      R.div(
        {className: "block-table__tr block-table__tr--dialogue"},
        [
          R.div({className: "block-table__td"},
            R.div({className: "#{iconClass} _organization-logo"},
              @.props.dialogue.sender_name[0])
          ),
          R.div({className: "block-table__td"},
            R.a({href: "#{@.props.dialogue.organization_path}"},
              @.props.dialogue.sender_name)
            ),
          R.div({className: "block-table__td text-grey"},
            "#{@.props.dialogue.messages_count} #{messagesWord}"),
          R.div({className: "block-table__td text-grey"},
            @.props.dialogue.unread),
          R.div({className: "block-table__td"},
            @.props.dialogue.last_message),
          R.div({className: "block-table__td"},
            if @.props.dialogue.time
              [
                R.span({},
                  @.props.dialogue.time.first_part
                ),
                R.span({className: "text-gray"},
                  @.props.dialogue.time.second_part
                )
              ]
          )
        ]
      )
