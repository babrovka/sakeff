`/** @jsx React.DOM */`
R = React.DOM

@TasksTableHeaderFilterPopoverTitleBeta = React.createClass

  mixins: [@TasksTableHeaderShareElementsPopoverMixin]

  getDefaultProps: ->
    filter_header: 'Фильтр по названию задачи'

  render: ->
    popover_body = [
      @.render_header(),
      @.render_form([
        R.input({name: 'title_cont', type: 'text', className: 'form-control'})
      ])
    ]

    @.renderPopover(popover_body)

