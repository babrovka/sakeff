`/** @jsx React.DOM */`

R = React.DOM

# рисуем много циркулярных сообщений
@.app.widgets.ImView = React.createClass
  getInitialState : ->
    messages: []

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
        R.hr({className: '_im__header _hr' }),
        R.div({className: '_im__body'}, messages)
        R.div({className: '_im__footer'},
          Form()
        )
      ])
    else
      R.div({}, 'у вас нет прав на чтение Циркуляра')




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

    R.div({className: '_im-message'},[
      message_header,
      message_body
    ])


# форма отправки сообщения на сервер
Form = React.createClass
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
        @.authenticityToken(),
        @.textField()
      ])

    else
      R.div({}, 'нет прав на отправку сообщений в циркуляр')