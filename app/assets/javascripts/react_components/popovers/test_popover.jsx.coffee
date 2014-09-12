`/** @jsx React.DOM */`

R = React.DOM

@TestPopover = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    body : ''
    unitId: null
    unitName: null



  render : ->
    header = R.div({className: 'h4 popover-header'}, @.props.unitName)

    _form = R.form({
        action: "/units/#{@.props.unitId}/bubbles"
        method: 'POST'
      },
      AuthenticityToken()
      Select(name: 'unit_bubble[bubble_type]')
      TextField(name: 'unit_bubble[comment]')
      Submit()
    )
    body = R.div({className: 'row'}, _form)

    @.renderPopover([header, body])



Select = React.createClass
  getDefaultProps: ->
    types: $('.js-new-bubble-form-mock').data('types')
    name: ''

  render: ->
    R.div({ className : 'form-group', 'data-remote': true }, [
      R.div({ className: 'col-7' }, [
        R.select({ name: @.props.name, className: 'form-control' },
          R.option(null, 'выберите значение')
          @.props.types.map((obj) ->
            R.option({ value : obj.value }, obj.translate)
          )
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
    R.div({ className : 'form-group' }, [
      R.div({ className : 'col-12' },
        R.input({ type: 'submit', className : 'btn' })
      )
    ])

AuthenticityToken = React.createClass
  getDefaultProps : ->
    val : $('.js-new-bubble-form-mock [name="authenticity_token"]').val()

  render : ->
    R.input({ type : 'hidden', value: @.props.val, name: 'authenticity_token' })
