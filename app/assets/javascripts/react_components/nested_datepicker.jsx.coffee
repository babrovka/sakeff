`/** @jsx R */`

R = React.DOM

@NestedDatepicker = React.createClass(
  displayName: "NestedDatepicker"
  getDefaultProps: ->
    start_date_min_date: "start_date_min_date"
    finish_date_max_date: "finish_date_max_date"

  getInitialState: ->
    start_date_min_date: null
    finish_date_max_date: null


  componentDidMount: ->
    $(".js-react-datepicker").datepicker _.extend(global.datepicker,
      onSelect: =>
        @.handleChange()
        return
    )
    event_name = @props.nested_name + ".date_selection.date_range_component"
    $(document).on event_name, (e, send_obj) =>
      @.setState
        start_date_min_date: send_obj.start_date
        finish_date_max_date: send_obj.finish_date

      return

    return

  renderDatePicker: (className, inputName) ->
    R.div
      className: "col-sm-2" + " " + className
    , R.div(
        className: "input-group"
      , R.div(
          className: "input-group-icon"
        , R.span(className: "fa fa-calendar")), R.input(
          className: "datepicker optional form-control js-react-datepicker form-control"
          name: inputName
          ref: className
        ))

  componentDidUpdate: ->
    $(@refs.inputclass.getDOMNode()).datepicker "option", "minDate", moment(@state.start_date_min_date, "DD.MM.YYYY")._d
    $(@refs.inputclass.getDOMNode()).datepicker "option", "maxDate", moment(@state.finish_date_max_date, "DD.MM.YYYY")._d  unless @state.finish_date_max_date is ""
    return

  render: ->
    R.div {className: "row"}, [@renderDatePicker("inputclass", "input-input")]
)