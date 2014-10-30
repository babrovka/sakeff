`/** @jsx React.DOM */`

R = React.DOM

# Основная вьюха виджета
@.app.widgets.ImView = React.createClass
  getInitialState : ->
    messages: []
    dialogues: []
    selected: null

  changeDialogueHandler: (dialogue_id) ->
    @.props.changeSelectedDialogue(dialogue_id)

  componentDidMount: ->
    if !!@.refs.scrollable
      $(@.refs.scrollable.getDOMNode()).customScrollbar
        skin: "default-skin"
        hScroll: false
        animationSpeed: 0
        wheelSpeed: 10
        swipeSpeed: 15
        fixedThumbHeight: 70
    
  componentDidUpdate: ->
    if !!@.refs.scrollable && @.state.messages.length
      $(@.refs.scrollable.getDOMNode()).customScrollbar("scrollTo", ".js-dialogue-message:last")
      $(@.refs.scrollable.getDOMNode()).customScrollbar("resize", true)

  renderDefaultText: ->
    R.div(null, 'Нет доступных диалогов')

  render: ->
    messages = @renderDefaultText()
    if @.state.messages.length
      messages = @.state.messages.map (message) ->
        [Message(message: message.attributes, key : message.id), R.hr({key : "hr-#{message.id}"})]

    R.div({className: '_im spec-im-widget'}, [
      R.div({className: '_im__header'},
        DialoguesList(dialogues: @.state.dialogues, onChangeDialogue: @.changeDialogueHandler)
      ),
      R.hr({className: '_im__header _hr' }),
      R.div({className : '_im__body', ref : 'scrollable'},
        R.div({className : '_im__body-container'}, messages)
      ),
      R.div({className: '_im__footer'},
        Form(selected: @.state.selected)
      )
    ])


# Рисуем список диалогов
# Только селект по входящим диалогам
DialoguesList = React.createClass
  getDefaultProps: ->
    dialogues: []

  changeSelectHandler: ->
    selected_id = @.refs.list.getDOMNode().selectedOptions[0].value
    @.props.onChangeDialogue(selected_id)

  render: ->
    options = @.props.dialogues.map (dialogue) ->
      R.option({key: dialogue.receiver_id, value: dialogue.receiver_id}, dialogue.sender_name)

    if !!@props.dialogues && @props.dialogues.length
      R.select({onChange: @.changeSelectHandler, ref: 'list'}, options)
    else
      R.div(null)


# Рисуем одно сообщение в списке
Message = React.createClass
  render : ->
    message = @.props.message

    message_header = R.div({className: '_im-message__header'},[
      R.span({className: '_im-message__org-title'}, message.sender_user.organization.short_title),
      R.span({className: '_im-message__sender-name'}, "#{message.sender_user.first_name} #{message.sender_user.last_name}")
      R.span({className: '_im-message__date'}, moment(message.created_at).format('HH:MM'))
    ])
    message_body = R.div({className: '_im-message__text'}, message.text)

    R.div({className: '_im-message js-dialogue-message'},[
      message_header,
      message_body
    ])


# форма отправки сообщения на сервер
Form = React.createClass

  utf8Input: ->
    R.input({ type : 'hidden', name : 'utf8', value: '✓'})

  authenticityToken: ->
    R.input({ type : 'hidden', value : $("meta[name=\"csrf-token\"]").attr("content"), name : 'authenticity_token' })

  textField: ->
    R.input({ type : 'string', name: 'im_message[text]', className: 'form-control spec-im-widget-form-input', placeholder: 'для отправки сообщения нажмите Enter'})

  componentDidMount: ->
    $(document).on('ajax:complete', @.refs.form.getDOMNode(), =>
      @.formSubmitHandler()
    )

  formSubmitHandler : ->
    @.refs.form.getDOMNode().reset()

  render : ->
    if !!@props.selected
      R.form({
          action : @props.selected.send_message_path
          method : 'POST'
          'data-remote' : true
          className : '_im-form horizontal-form'
          ref : 'form'
          key: @props.selected.receiver_id
        },[
        R.div({className: 'hidden'}, [
          @.authenticityToken(),
          @.utf8Input()
        ]),
        @.textField()
      ])

    else
      R.form({ref : 'form', key: 'unavailable'})