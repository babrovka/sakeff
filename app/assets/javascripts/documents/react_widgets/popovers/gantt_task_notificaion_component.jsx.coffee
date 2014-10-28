`/** @jsx React.DOM */`

R = React.DOM

@NotificationPopover = React.createClass
  mixins: [PopoverMixin]

  propTypes:
    json: React.PropTypes.object

  getDefaultProps: ->
    json: {}
    data: []

  activateParent: ->
#    if @.state.opened
#      $(".task_notifications_container#{@.props.parent}").addClass('active');
#    else
#      $(".task_notifications_container#{@.props.parent}").removeClass('active');


  render: ->
    @.activateParent()

    task = @.props.json
    data = task.notifications

    current_date = moment(@.props.json.date, 'DD-MM-YYYY').format('DD MMMM, dddd')

    header = R.div({className: 'b-offset-sm'},
      [
        R.div({className: 'row'},[
            R.div({className: 'col-sm-11 col-sm-offset-1'},
              R.span({className: 'popover-title m-tasks-gantt-sqplus'}, task.title)
            )
          ]
        ),
        R.div({className: 'row'}, [
          R.div({className: 'col-sm-6 col-sm-offset-1'},
            [
              R.span({className: 'popover-title'}, "#{moment(task.started_at).format('DD MMMM')} - #{moment(task.finished_at).format('DD MMMM')}")
            ]

          ),
          R.div({className: 'col-sm-5'},
            R.span({className: 'popover-title'}, task.notifications_count+' новых событий')
          )
        ])
      ]
    )

    notifications =  data.map((el) ->
      R.div({className: 'row'},[
        R.div({className: 'col-sm-11 col-sm-offset-1 text-cloud'}, [
          R.span({className: 'text-gray'}, el.user+': '),
          R.span({className: ''}, el.message)
        ])
      ])
    )


#    items = data.map((el) ->
#      R.div({className: 'popover-content-item b-offset-sm'}, [
#        R.div({className: 'row'},[
#          R.div({className: 'col-sm-1 col-sm-offset-1'}, R.input({type: 'checkbox', checked: el.checked, disabled: 'disabled'})),
#          R.div({className: 'col-sm-9'}, R.a({className: 'h4 link-sea-green', href: "/tasks/#{task_id}"}, el.name))
#        ]),
#        render_description(el),
#      ])
#    )

    bottom_links =
      R.div({className: 'popover-footer nav nav-justified'}, [
          R.li({}, R.a({className: 'col-sm-6 btn text-center', href: "/tasks/#{task.id}"}, 'Открыть задачу') ),
          R.li({}, R.a({className: 'col-sm-6 btn text-center', onClick: @.popoverHide}, [ R.span({className: 'fa fa-ban'}), R.span({}, 'Отмена') ]) )
      ])

    @.renderPopover([header, notifications, bottom_links])

