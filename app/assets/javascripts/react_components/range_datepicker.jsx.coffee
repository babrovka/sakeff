`/** @jsx R */`

R = React.DOM

@RangeDatepicker = React.createClass(
  displayName: "DatePicker"
  getDefaultProps: ->
    start_date_input_name: "start_date"
    finish_date_input_name: "finish_date"
    can_earlier_than_today: true
    start_date_min_date: null
    start_date_value: null
    finish_date_value: null

  componentDidMount: ->
    $(".js-react-datepicker").datepicker _.extend(global.datepicker,
      onSelect: =>
        @.handleChange()
        return
    )
    @handleChange()
    return

  renderStartEndDatePicker: (className, inputName, value) ->
    R.div
      className: "col-sm-2" + " " + className
      key: inputName
    , R.div(
        className: "input-group"
      , R.div(
          className: "input-group-icon"
        , R.span(className: "fa fa-calendar")), R.input(
          className: "datepicker optional form-control js-react-datepicker form-control"
          name: inputName
          ref: className
          value: value
          onChange: @handleChange
        ))

  handleChange: ->
    # что-то творим с датами
    dates = @.calculateDates()

    # настраиваем datepicker
    $(@refs.start_date.getDOMNode()).datepicker "option", "minDate", dates.start_date
    $(@refs.finish_date.getDOMNode()).datepicker "option", "minDate", dates.finish_date

    send_obj =
      start_date : @.refs.start_date.getDOMNode().value
      finish_date : @.refs.finish_date.getDOMNode().value

    # посылаем связанному datepicker настройки
    @.sendParamsToNestedDatepickers(send_obj)

    @

  # создаем event для связанных datepicker
  # отсылаем текущие даты начала и конца
  sendParamsToNestedDatepickers: (send_obj) ->
    event_name = @props.nested_name + ".date_selection.date_range_component"
    $(document).trigger event_name, send_obj

    send_obj

  # высчитываем даты, которыми будем настраивать datepicker
  # возвращаем объект
  # { start_date: Date, finish_date: Date }
  calculateDates: ->
    datepickerStartDate = null
    datepickerStartDateOfFinishDate = null

    # сегодняшнюю дату обнуляем до 00 часов 00 минут,
    # чтобы верно работали 'if' в нашем методе
    today = moment().hours(0).minutes(0).seconds(0).milliseconds(0)
    currentStartDateInputVal = @refs.start_date.getDOMNode().value
    currentFinishDateInputVal = @refs.finish_date.getDOMNode().value

    currentStartDateInput = moment(currentStartDateInputVal, "DD.MM.YYYY")
    currentFinishDateInput = moment(currentFinishDateInputVal, "DD.MM.YYYY")


    # разный парсинг в зависимости от формата даты
    # формат либо 24.10.2014 либо UTC формат
    propsStartDateMinDate = @.parseIncomeDates().startDate

    # создание для start_date
    # если ее ничего не ограничивает,то в ней будет null и на datepicker это не повлияет
    # установлено > сегодня ==> установлено
    # установлено < сегодня ==> сегодня
    # не установлено ==> сегодня
    if @.props.can_earlier_than_today is false
      datepickerStartDate = today
      datepickerStartDate = propsStartDateMinDate if @.props.start_date_min_date? && propsStartDateMinDate > today

    else
      datepickerStartDate = propsStartDateMinDate if @.props.start_date_min_date?

    # создание для finish_date для дэйтпикера
    datepickerStartDateOfFinishDate = today
    datepickerStartDateOfFinishDate = currentStartDateInput if currentStartDateInput > today


    # все даты в объектах типа moment
    {
      start_date: datepickerStartDate._d
      finish_date: datepickerStartDateOfFinishDate._d
    }

  # парсим параметры инициализации
  # приводим к объектам Moment
  parseIncomeDates: ->
    parse_params = "DD.MM.YYYY"# unless startDay.length > 10

    {
      startDate: moment(@.props.start_date_min_date, parse_params)
    }


  render: ->

    React.DOM.div({className: "row"},  [
      this.renderStartEndDatePicker("start_date", @.props.start_date_input_name, @.props.start_date_value)
      this.renderStartEndDatePicker("finish_date", @.props.finish_date_input_name, @.props.finish_date_value)
    ]);
)