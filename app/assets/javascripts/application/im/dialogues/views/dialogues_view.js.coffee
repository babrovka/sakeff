R = React.DOM

# Dialogues view which renders dialogues
# @note is created in DialoguesController
# @param componentDidMountCallback [Function] what will call after view render
@.app.DialoguesView = React.createClass
  getInitialState: ->
    {
      dialoguesData: []
    }


  componentDidMount: ->
    @.props.componentDidMountCallback()

    $(document).on "mouseenter", ".block-table__tr--dialogue", (e) =>
      $correctDialogueObject = $(e.target).closest(".block-table__tr--dialogue")
      @renderPopover($correctDialogueObject)
    $(document).on "mouseleave", ".block-table__tr--dialogue", =>
      @hidePopover()


  # Renders popover with additional info
  # @note is triggered on dialogue hover
  # @param $dialogue [jQuery DOM] dialogue which is being hovered on
  # @todo remove bad constant
  renderPopover: ($dialogue) ->
    visiblePartHeight = $dialogue.height()
    $nextDialogue = $dialogue.next(".block-table__tr--dialogue")
    PADDING_SIZE = 16
    $nextDialogue.css({"margin-top": "-#{visiblePartHeight - PADDING_SIZE}px"})
    $dialogue.addClass("m-hovered")


  # Hides those monstrous popovers
  # @note is triggered on dialogue hover
  hidePopover: ->
    $allDialogues = $(".block-table__tr--dialogue")
    $allDialogues.removeClass("m-hovered").css({"margin-top": 0})


  render: ->
    if @.state.dialoguesData.length
      DialogueTable(dialoguesData: this.state.dialoguesData)
    else
      R.h2(
        {},
        "Загрузка диалогов..."
      )


  # Whole table
  # @note is called in render
  # @param dialoguesData [JSON]
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
      titles = ["Название", "Сообщений всего", "Непрочитанных", "Последнее сообщение", "Время"]
      R.header(
        {className: "block-table__thead row"},
        [
          R.div({className: "block-table__th col-1"},
            ""
          ),
          titles.map (title) ->
            R.div({className: "block-table__th col-2"},
              title
            )
        ]
      )


  # Dialogue table row
  # @note is rendered in DialogueTable for each dialogue
  # @param dialogue [JSON]
  Dialogue = React.createClass

    rowClickHandler: ->
      window.location = @.props.dialogue.organization_path

    render: ->
      R.div(
        {className: "block-table__tr block-table__tr--dialogue row", onClick: @rowClickHandler},
        [
          DialogueVisiblePart(dialogue: @.props.dialogue),
          DialogueInvisiblePart(dialogue: @.props.dialogue)
        ]
      )


  # Always visible part
  # @note is rendered in Dialogue
  # @param dialogue [JSON]
  DialogueVisiblePart = React.createClass
    render: ->
      R.div(
        {className: "block-table__visible"},
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
          DialogueMessagesCount(
            messages_count: @.props.dialogue.unread
          ),
          R.div(
            {className: "block-table__td col-2"},
            R.span({},
              @.props.dialogue.last_message_time
            )
          ),
          R.div(
            {className: "block-table__td col-2"},
            DialogueTime(
              time: @.props.dialogue.time
            )
          )
        ]
      )


  # Only visible on hover part
  # @note is rendered in Dialogue
  # @param dialogue [JSON]
  DialogueInvisiblePart = React.createClass
    render: ->
      R.div(
        {className: "block-table__invisible"},
        [
          R.div(
            {className: "row"},
            [
              EmptyCell(),
              R.div(
                {className: "block-table__td col-11"},
                [
                  R.span(
                    {},
                    "#{@.props.dialogue.last_message_time} "
                  ),
                  R.span(
                    {},
                    DialogueTime(time: @.props.dialogue.time)
                  ),
                  R.span(
                    {className: "block-table__last_message"},
                    @.props.dialogue.last_message_message
                  )
                ]
              )
            ]
          ),
          R.div(
            {className: "row"},
            [
              EmptyCell(),
              R.div(
                {className: "block-table__td col-11"},
                R.a(
                  {href: "#{@.props.dialogue.organization_path}"},
                  "+ еще #{@.props.dialogue.messages_count} #{window.app.Pluralizer.pluralizeString(@.props.dialogue.messages_count, "сообщение","сообщения","сообщений")}"
                )
              )
            ]
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
        {className: "block-table__td col-1"},
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
        {className: "block-table__td col-2"},
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
        {className: "block-table__td text-gray col-2"},
        "#{@.props.messages_count} #{messagesWord}"
      )


  # @note is rendered in Dialogue
  # @param time [String]
  DialogueTime = React.createClass
    render: ->
      R.span(
        {},
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

  # Empty cell which is used just for grid purposes in a Dialogue
  EmptyCell = React.createClass
    render: ->
      R.div(
        {className: "block-table__td col-1"},
        ""
      )
