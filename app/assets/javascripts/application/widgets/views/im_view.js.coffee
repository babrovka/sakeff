`/** @jsx React.DOM */`

R = React.DOM

# рисуем много циркулярных сообщений
@.app.widgets.ImView = React.createClass
  getInitialState : ->
    messages: []

  componentDidUpdate: ->
    unless !@.refs.scrollable
      console.log($(@.refs.scrollable.getDOMNode()).children().find('.js-dialogue-message:last')[0])
      $(@.refs.scrollable.getDOMNode()).customScrollbar
        skin: "gray-skin"
        hScroll: false
        animationSpeed: 0
      $(@.refs.scrollable.getDOMNode()).customScrollbar("scrollTo", ".js-dialogue-message:last")


  componentDidMount : ->
    @.props.componentDidMountCallback() if @.props.hasOwnProperty('componentDidMountCallback')

  render: ->
    if app.CurrentUser.hasPermission('read_broadcast_messages')
      messages = @.state.messages.map (message) ->
        [Message(message: message.attributes, key : message.id), R.hr()]

      R.div({className: '_im'}, [
        R.div({className: '_im__header'},
          [R.span({}, 'Циркуляр'), R.span({className : 'fa fa-angle-down'})]
        ),
        R.div({className: '_im__body', ref: 'scrollable'},
          R.div({className: '_im__body-container'}, messages)
        )
        R.hr({className: '_im__header _hr' }),
        R.div({className: '_im__footer'},
          Form()
        )
      ])
    else
      R.div({}, 'у вас нет прав на чтение Циркуляра')


MessagesList = React.createClass
  getDefaultProps: ->
    messages: []

  render: ->




# рисуем одно сообщение в списке
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
    R.input({ type : 'string', name: 'im_message[text]', className: 'form-control', placeholder: 'для отправки сообщения нажмите Enter'})

  componentDidMount: ->
    $(@.refs.form.getDOMNode()).on('ajax:complete', =>
      @.formSubmitHandler()
    )

  formSubmitHandler : ->
    @.refs.form.getDOMNode().reset()

  render : ->
    if app.CurrentUser.hasPermission('send_broadcast_messages')
      R.form({
          action : "/messages/broadcast"
          method : 'POST'
          'data-remote' : true
          className : '_im-form horizontal-form'
          ref : 'form'
        },[
        R.div({className: 'hidden'}, [
          @.authenticityToken(),
          @.utf8Input()
        ]),
        @.textField()
      ])

    else
      R.div({}, 'нет прав на отправку сообщений в циркуляр')