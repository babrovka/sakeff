`/** @jsx React.DOM */`

R = React.DOM

@FlagPopover = React.createClass
  mixins: [PopoverMixin]

  propTypes:
    json: React.PropTypes.object

  getDefaultProps: ->
    json: {}
    data: []

  activateParent: ->
    if @.state.opened
      $(".task_flag#{@.props.parent}").addClass('active');
    else
      $(".task_flag#{@.props.parent}").removeClass('active');


  componentDidUpdate: ->
    $(@.refs.popover.getDOMNode()).find('input[type="checkbox"]').iCheck(global.icheck)

  render: ->
    @.activateParent()


    data = @.props.json.data
    task_id = @.props.json.task_id
    window.task_date = @.props.json.date
    current_date = moment(@.props.json.date, 'DD-MM-YYYY').format('DD MMMM, dddd')

    header = R.div({},
      R.div({className: 'row'},[
          R.div({className: 'col-sm-9 col-sm-offset-1'},
            R.div({className: 'popover-title m-tasks-gantt-flag'}, current_date)
          )
        ]
      )
    )
    
    render_description = (el) ->
      description = R.div({})
      unless _.isUndefined(el.description) || _.isEmpty(el.description)
        description = R.div({className: 'row'}, [
          R.div({className: 'col-sm-1 col-sm-offset-1'}, R.div({className: 'text-help'}, 'суть')),
          R.div({className: 'col-sm-9'}, R.p({className: 'text-cloud'}, el.description))
        ])

    items = data.map((el) ->
      R.div({className: 'popover-content-item b-offset-sm'}, [
        R.div({className: 'row'},[
          R.div({className: 'col-sm-1 col-sm-offset-1'}, R.input({type: 'checkbox', checked: el.checked, disabled: 'disabled'})),
          R.div({className: 'col-sm-9'}, R.a({className: 'h4 link-sea-green', href: "/tasks/#{task_id}"}, el.name))
        ]),
        render_description(el),
      ])
    )

    bottom_links =
      R.div({className: 'popover-footer nav nav-justified'}, [
          R.li({}, R.a({className: 'col-sm-4 btn text-center', href: "/tasks/#{task_id}"}, 'Открыть задачу') ),
          R.li({}, R.a({className: 'col-sm-4 btn text-center', href: "/tasks/#{task_id}/edit#checklist"}, 'Править дела') ),
          R.li({}, R.a({className: 'col-sm-4 btn text-center', onClick: @.popoverHide}, [ R.span({className: 'fa fa-ban'}), R.span({}, 'Отмена') ]) )
      ])

    @.renderPopover([header, items, bottom_links])

