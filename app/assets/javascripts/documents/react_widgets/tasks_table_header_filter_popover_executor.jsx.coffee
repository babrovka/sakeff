`/** @jsx React.DOM */`
R = React.DOM

@TasksTableHeaderFilterPopoverExecutor = React.createClass

  getDefaultProps: ->
    opened: false
    filter_opts: {
                    data: [ { id: '0', text: 'Unknown User' } ]
                    input_names: ['']
                  }


  getInitialState: (props) ->
    props = props || this.props
    opened: props.opened


  componentWillReceiveProps: (newProps, oldProps) ->
    @.setState(@.getInitialState(newProps))

  handleSubmit: (e) ->
    e.preventDefault()
    @.props.onPopoverSubmit(
      $(@.refs.popover_filter_form.getDOMNode()).serializeObject()
    )


  componentDidUpdate: ->
#    $('.js-select2').select2('data', @.props.filter_opts.data)

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

  handleCancel: ->
    @.props.onPopoverCancel(false)

  popoverClassName: ->
    class_name = ['popover popover-right']
    class_name.push 'hidden' unless @.state.opened
    class_name.join(' ')


  handleBodyClick: (e) ->
    console.log 'h'
    if (@.state.opened)
      @.setState opened: false



  render: ->
    input_name = try
                    @.props.filter_opts.input_names[0]
                  catch
                    ''


    R.div({className: @.popoverClassName()}, [
      R.h5({className: 'popover-header'}, 'Фильтр по полю'),
      R.form({ref: 'popover_filter_form', onSubmit: @.handleSubmit, className: 'form-vertical'}, [
        R.div({className: 'popover-body'}, [
          R.input({name: input_name, className: 'js-select2', multiple: 'multiple'})
        ]),
        R.a({href: '#', onClick: @.handleSubmit, className: 'popover-btn'},[
          R.span({className: 'popover-fa fa fa-check-circle'})
          R.span({}, 'применить')
        ]),
        R.a({href: '#', onClick: @.handleCancel, className: 'popover-btn'},[
          R.span({className: 'popover-fa fa fa-ban'})
          R.span({}, 'отменить')
        ])
      ])
    ])

