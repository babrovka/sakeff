`/** @jsx React.DOM */`
R = React.DOM

@TasksTableHeaderFilterPopoverStartedAtBeta = React.createClass

  mixins: [@TasksTableHeaderShareElementsPopoverMixin]

  getDefaultProps: ->
    filter_header: 'Фильтр по времени'

  render: ->
    left_input_name = try
      @.props.filter_opts.input_names[0]
    catch
      ''

    right_input_name = try
      @.props.filter_opts.input_names[1]
    catch
      ''

    popover_body = [
      @.render_header(),
      @.render_form(
        R.div({className: 'row'}, [
          R.div({className: 'col-sm-6'},
            R.div({className: 'row'}, [
              R.label({className: 'control-label col-sm-2'}, 'от'),
              R.div({className: 'col-sm-10'},
                R.div({className: 'input-group'}, [
                  R.div({className: 'input-group-icon'}, R.span({className: 'fa fa-calendar'})),
                  R.input({name: left_input_name, type: 'text', className: 'form-control js-datepicker'})
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
                  R.input({name: right_input_name, type: 'text', className: 'form-control js-datepicker'})
                ])
              )
            ])
          )
        ])
      )
    ]

    @.renderPopover(popover_body)


