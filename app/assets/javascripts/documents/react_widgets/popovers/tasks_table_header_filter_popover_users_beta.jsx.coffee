`/** @jsx React.DOM */`
R = React.DOM

@TasksTableHeaderFilterPopoverUsersBeta = React.createClass

  mixins: [@TasksTableHeaderShareElementsPopoverMixin]

  getDefaultProps: ->
    filter_header: 'Фильтр по участникам'

  propTypes:
    filter_opts: React.PropTypes.object

  componentDidMount: ->
    $('.js-select2').select2(
      multiple: true
      width: '100%'
      containerCssClass: 'select2-black-mode'
      dropdownCssClass: 'select2-black-mode'
      query: (query) =>
        data =
          results: []
        $.each @.props.filter_opts.data, ->
          if query.term.length is 0 or @text.toUpperCase().indexOf(query.term.toUpperCase()) >= 0
            data.results.push
              id: @.id
              text: @.title
          return
        query.callback data
    )

  render: ->
    input_name = try
      @.props.filter_opts.input_names[0]
    catch
      ''

    popover_body = [
      @.render_header(),
      @.render_form([
        R.input({name: input_name, className: 'js-select2', multiple: 'multiple'})
      ])
    ]

    @.renderPopover(popover_body)




#  mixins: [PopoverMixin]
#
#
#
#  handleSubmit: (e) ->
#    e.preventDefault()
#    @.props.onPopoverSubmit(
#      $(@.refs.popover_filter_form.getDOMNode()).serializeObject()
#    )
#    @.popoverHide()
#
#  handleCancel: ->
#    @.popoverHide()
#
#
#
#
#  render: ->
#
#
#
#    popover_body = [
#      R.h5({className: 'popover-header'}, 'Фильтр по полю'),
#      R.form({ref: 'popover_filter_form', onSubmit: @.handleSubmit, className: 'form-vertical'}, [
#        R.div({className: 'popover-body'}, [
#          R.input({name: input_name, className: 'js-select2', multiple: 'multiple'})
#        ]),
#        R.a({href: '#', onClick: @.handleSubmit, className: 'popover-btn'},[
#          R.span({className: 'popover-fa fa fa-check-circle'})
#          R.span({}, 'применить')
#        ]),
#        R.a({href: '#', onClick: @.handleCancel, className: 'popover-btn'},[
#          R.span({className: 'popover-fa fa fa-ban'})
#          R.span({}, 'отменить')
#        ])
#      ])
#    ]
#
#    @.renderPopover(popover_body)

