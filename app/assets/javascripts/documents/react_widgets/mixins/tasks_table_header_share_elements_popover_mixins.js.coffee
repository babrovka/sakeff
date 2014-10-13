`/** @jsx React.DOM */`

###
  React Mixin для отрисовки
  - заголовок
  - области под форму
  - кнопки «применить» и «отмена»
  в поповерах, отвечающих за отрисовку фильтров к списку задач



###

R = React.DOM


@TasksTableHeaderShareElementsPopoverMixin =

  mixins: [PopoverMixin]

  handleSubmit: (e) ->
    e.preventDefault()
    @.props.onPopoverSubmit(
      $(@.refs.popover_filter_form.getDOMNode()).serializeObject()
    )
    @.popoverHide()

  handleCancel: ->
    @.popoverHide()


  render_header: ->
    R.h3({className: 'popover-title m-tasks-table-filter'}, @.props.filter_header)

  render_submit_button: ->
    R.div({className: 'btn-group-vertical'}, [
      R.a({href: '#', onClick: @.handleSubmit, className: 'btn'}, [
        R.span({className: 'popover-fa fa fa-check-circle'})
        R.span({}, 'применить')
      ]),
      R.a({href: '#', onClick: @.handleCancel, className: 'btn'}, [
        R.span({className: 'popover-fa fa fa-ban'})
        R.span({}, 'отменить')
      ])
    ])

  render_form: (reactDOM) ->
    R.form({ref: 'popover_filter_form', onSubmit: @.handleSubmit, class: 'form-horizontal'}, [
      R.div({className: 'popover-form m-tasks-table-filter'}, [
        reactDOM
      ]),
      @.render_submit_button()
    ])