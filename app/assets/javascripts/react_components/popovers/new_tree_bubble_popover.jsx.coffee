`/** @jsx React.DOM */`

R = React.DOM

@app.NewTreeBubblePopover = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    body : ''
    unitId: null
    unitName: null
    type: null


  componentDidMount: ->
    $(@.refs.form.getDOMNode()).on('ajax:complete', =>
      @.formSubmitHandler()
    )

  formSubmitHandler: ->
    @.refs.form.getDOMNode().reset()
    @.popoverHide()

  render : ->
    # If rendered on dashboard with preselected type
    if @.props.type && @.props.type.nameRussian
      subtitle = "типа #{@.props.type.nameRussian}"
    else
      subtitle = ""
    title = "Добавить статус к объекту\n#{@.props.unitName} #{subtitle}"
    header = R.div({className: 'h4 popover-header'}, title)

    _form = R.form({
        action: "/units/#{@.props.unitId}/bubbles"
        method: 'POST'
        'data-remote': true
        className: 'form-horizontal js-add-bubble-form js-ajax-wait-response'
        ref: 'form'
      },
      R.div({className: 'popover-form-content'},[
        Select(
          name: 'unit_bubble[bubble_type]',
          type: @.props.type
        )
        TextField(name: 'unit_bubble[comment]')
      ])
      AuthenticityToken()
      R.div({ className: 'popover-footer' }, Submit())
    )
    body = R.div({className: 'row'}, _form)

    @.renderPopover([header, body])



Select = React.createClass
  getDefaultProps: ->
    types: $('.js-new-bubble-form-mock').data('types')
    name: ''
    type: null

  render: ->
    # Because type can also be 0
    # If rendered on dashboard with preselected type
    if @.props.type != null
      options =
        [R.option({ value: @.props.type.name }, @.props.type.nameRussian)]
      className = "hidden"
    else
      options =
        [R.option({ value: null, disabled: true }, 'Выберите тип события'),
        @.props.types.map((obj) ->
          R.option({ value : obj.value }, obj.translate)
        )]
      className = ""

    R.div({ className : "form-group #{className}" }, [
      R.div({ className: 'col-7' }, [
        R.select({ name: @.props.name, className: "form-control" },
          options
        )
      ])
    ])


TextField = React.createClass
  getDefaultProps : ->
    name : ''

  render : ->
    R.div({ className: 'form-group' }, [
      R.div({ className: 'col-12' },
        R.textarea({ name : @.props.name, rows: 3, className: 'form-control' })
      )
    ])


Submit = React.createClass
  getDefaultProps : ->
    name : ''

  render : ->
    R.div(null,
      R.input({ type: 'submit', className : 'link m-green', value: 'Сохранить' })
    )

AuthenticityToken = React.createClass
  getDefaultProps : ->
    val : $('.js-new-bubble-form-mock [name="authenticity_token"]').val()

  render : ->
    R.input({ type : 'hidden', value: @.props.val, name: 'authenticity_token' })
