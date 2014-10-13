`/** @jsx React.DOM */`
R = React.DOM

@TasksTableHeaderFilterPopoverStartedAt = React.createClass

  getDefaultProps: ->
    opened: false

  handleSubmit: (e) ->
    e.preventDefault()
    @.props.onPopoverSubmit(
      $(@.refs.popover_filter_form.getDOMNode()).serializeObject()
    )

  handleCancel: ->
    @.props.onPopoverCancel(false)


  render: ->
    class_name = 'popover popover-right '
    class_name += (if @.props.opened then "" else "hidden")
    R.div({className: class_name}, [
      R.h5({className: 'popover-header'}, 'Фильтр по полю'),
      R.form({ref: 'popover_filter_form', onSubmit: @.handleSubmit, className: 'form form-horizontal'}, [
        R.div({className: 'row popover-body'},

          R.div({className: 'col-sm-6'},
            R.div({className: 'row'}, [
              R.label({className: 'control-label col-sm-2'}, 'от'),
              R.div({className: 'col-sm-10'},
                R.div({className: 'input-group'}, [
                  R.div({className: 'input-group-icon'}, R.span({className: 'fa fa-calendar'})),
                  R.input({name: 'started_at_gteq', type: 'text', className: 'form-control js-datepicker'})
                ]),
              )
            ])
          ),

          R.div({className: 'col-sm-6 form-group'},
            R.div({className: 'row'}, [
              R.label({className: 'control-label col-sm-2'}, 'до'),
              R.div({className: 'col-sm-10'},
                R.div({className: 'input-group'}, [
                  R.div({className: 'input-group-icon'}, R.span({className: 'fa fa-calendar'})),
                  R.input({name: 'started_at_lteq', type: 'text', className: 'form-control js-datepicker'})
                ])
              )
            ])
          )

        )
        R.a({href: '#', onClick: @.handleSubmit, className: 'popover-btn'}, [
          R.span({className: 'popover-fa fa fa-check-circle'})
          R.span({}, 'применить')
        ]),
        R.a({href: '#', onClick: @.handleCancel, className: 'popover-btn'}, [
          R.span({className: 'popover-fa fa fa-ban'})
          R.span({}, 'отменить')
        ])
      ])
    ])

