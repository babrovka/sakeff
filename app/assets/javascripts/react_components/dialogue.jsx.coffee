`/** @jsx React.DOM */`

R = React.DOM

@.app.DialoguesContainer = React.createClass
  # Creates empty array for future data
  getInitialState: ->
    {
      dialoguesData: []
    }

  # Connects to a websockets channel and grabs initial data from server
  componentDidMount: ->
    new window.app.dialogueNotification("/broadcast/im/organizations", {}, {dialoguesContainer: @})
    @updateDialogues()


  render: ->
    if @.state.dialoguesData.length
      DialogueTable(dialoguesData: this.state.dialoguesData)
    else
      R.h2(
        {},
        "Здесь будут показаны диалоги..."
      )


  # Gets fresh dialogues info
  # @param
  updateDialogues: ->
    $.ajax
      url: this.props.dialoguesPath
      dataType: 'json'
      success: (data) =>
        this.setState({dialoguesData: data})
      error: (xhr, status, err) =>
        console.error(this.props.dialoguesPath, status, err.toString())


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
  # @note is rendered in DialogueTable
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


  # Dialogue table row
  # @note is rendered in DialogueTable for each dialogue
  # @param dialogue [JSON]
  Dialogue = React.createClass
    render: ->
      R.div(
        {className: "block-table__tr block-table__tr--dialogue"},
        [
          DialogueLogo(
            receiver_id: @.props.dialogue.receiver_id,
            sender_name: @.props.dialogue.sender_name
          ),
          DialogueLink(
            organization_path: @.props.dialogue.organization_path,
            sender_name: @.props.dialogue.sender_name
          ),
          DialogueMessagesCount(
            messages_count: @.props.dialogue.messages_count
          ),
          R.div(
            {className: "block-table__td text-grey"},
            @.props.dialogue.unread
          ),
          R.div(
            {className: "block-table__td"},
            @.props.dialogue.last_message
          ),
          DialogueTime(
            time: @.props.dialogue.time
          )
        ]
      )


  # @note is rendered in Dialogue
  # @param receiver_id [String]
  # @param sender_name [String]
  DialogueLogo = React.createClass
    render: ->
      iconClass = "m-#{@.props.receiver_id[0]}"
      R.div(
        {className: "block-table__td"},
        R.div(
          {className: "#{iconClass} _organization-logo"},
          @.props.sender_name[0]
        )
      )


  # @note is rendered in Dialogue
  # @param organization_path [String]
  # @param sender_name [String]
  DialogueLink = React.createClass
    render: ->
      R.div(
        {className: "block-table__td"},
        R.a(
          {href: "#{@.props.organization_path}"},
          @.props.sender_name
        )
      )


  # @note is rendered in Dialogue
  # @param messages_count [Integer]
  DialogueMessagesCount = React.createClass
    render: ->
      messagesWord = window.app.Pluralizer.pluralizeString(@.props.messages_count, "сообщение","сообщения","сообщений")
      R.div(
        {className: "block-table__td text-grey"},
        "#{@.props.messages_count} #{messagesWord}"
      )


  # @note is rendered in Dialogue
  # @param time [String]
  DialogueTime = React.createClass
    render: ->
      R.div(
        {className: "block-table__td"},
        if @.props.time
          [
            R.span(
              {},
              @.props.time.first_part
            ),
            R.span(
              {className: "text-gray"},
              @.props.time.second_part
            )
          ]
        else
          R.span(
            {},
            "Никогда"
          )
      )
