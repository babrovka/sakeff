`/** @jsx React.DOM */`

R = React.DOM

@GanttTaskSQPlus = React.createClass
  mixins: [PopoverMixin]

  propTypes:
    json: React.PropTypes.object

  getDefaultProps: ->
    json: {}
    placement: 'bottom'

  componentWillUpdate: ->
    @.props.target_position = $('.gantt_task_content'+@.props.parent).prev()[0]

  activeParent: ->
    if @.state.opened
      $(".gantt_task_content#{@.props.parent}").prev().addClass('active')
    else
      plus = $(".gantt_task_content#{@.props.parent}").prev()
      plus.removeClass('active')
      plus.hide()


  render: ->
    @.activeParent()

    data = @.props.json

    open_link = R.a({className: 'btn'}, [R.span({className: 'fa col-words-1'}), R.span({}, 'Открыть задачу')])
    add_subtask_link = R.a({className: 'btn', href: "/tasks/#{data.id}/edit#add_subtask"}, [R.span({className: 'fa fa-plus'}), R.span({}, 'Добавить подзадчу')])
    add_checklist_item_link = R.a({className: 'btn', href: "/tasks/#{data.id}/edit#add_checklist_item"}, [R.span({className: 'fa fa-plus'}), R.span({}, 'Добавить дело')])
    edit_link = R.a({className: 'btn', href: "/tasks/#{data.id}/edit"}, [R.span({className: 'fa fa-pencil'}), R.span({}, 'Редактировать задачу')])
    cancel_link = R.a({className: 'btn', onClick: @.popoverHide}, [R.span({className: 'fa fa-ban'}), R.span({}, 'Отмена')])

    data_range = "#{moment(data.started_at).format('DD MMMM')} - #{moment(data.finished_at).format('DD MMMM')}"

    header = R.div({className: 'row'},
              R.div({className: 'col-sm-9 col-sm-offset-1 b-offset-sm'},[
                R.div({className: 'popover-title m-tasks-gantt-sqplus'}, data.title),
                R.div({className: 'text-cloud'}, data_range)
              ])
    )
    items = R.div({className: 'btn-group-vertical'},[
              open_link,
              add_subtask_link,
              add_checklist_item_link,
              edit_link,
              cancel_link
            ])



    @.renderPopover([header, items])


