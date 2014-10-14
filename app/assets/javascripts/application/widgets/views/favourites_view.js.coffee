R = React.DOM
ELEMENT_CLASS = "_favourites"
#
# @note is created in
# @note is created in
# @param
@.app.widgets.FavouritesView = React.createClass
  getInitialState: ->
    {
      unitsData: []
    }


  componentDidUpdate: ->
    $('.js-select2').select2(global.select2)


  render: ->
    widgetHeader = R.header(
      {
        className: "#{ELEMENT_CLASS}__header"
      },
      [
        R.span(
          {
            className: "#{ELEMENT_CLASS}__header__icon"
          }
        ),
        R.h3(
          {
            className: "#{ELEMENT_CLASS}__header__title"
          },
          "Избранные объекты"
        )
      ]
    )

    favouriteUnits = _.where(@.state.unitsData, {is_favourite: true})
    favouriteForm =
      if favouriteUnits.length
        FavSelect(unitsData: favouriteUnits)
      else
        R.h2(
          {},
          "Здесь будет показаны избранные объекты"
        )

    R.div(
      {},
      [
        widgetHeader,
        favouriteForm,
        BubblesButtons()
      ]
    )

  #
  BubblesButtons = React.createClass
    render: ->
      addButtonsInfo = [
        {
          class: "#{ELEMENT_CLASS}__button--accident",
          iconClass: "fa-exclamation-triangle",
          typeInteger: 0
        },
        {
          class: "#{ELEMENT_CLASS}__button--work",
          iconClass: "fa-wrench",
          typeInteger: 1
        },
        {
          class: "#{ELEMENT_CLASS}__button--info",
          iconClass: "fa-bookmark",
          typeInteger: 2
        },
        {
          class: "#{ELEMENT_CLASS}__button--show pull-right"
          iconClass: "fa-crosshairs"
        }
      ]

      addButtons = _.map(addButtonsInfo, (button) ->
        addButton(button)
      )

      R.div(
        {
          className: "#{ELEMENT_CLASS}__buttons"
        },
        {addButtons}
      )


  addButton = React.createClass
    render: ->
      R.div(
        {
          className: "#{ELEMENT_CLASS}__button #{@.props.class}",
          "data-type-integer": @.props.typeInteger
        },
        R.i(
          {
            className: "fa #{@.props.iconClass}"
          }
        )
      )



  UnitOption = React.createClass
    render: ->
      R.option(
        {
          value: @.props.id
        },
        @.props.text
      )


  #
  FavSelect = React.createClass
    PLACEHOLDER_VALUE: "Выберите объект"

    #
    selectUnitOnTv: (e) ->
      unit_id = e.target.value
      unless unit_id == @PLACEHOLDER_VALUE
        PubSub.publish('unit.select', unit_id)

    render: ->
#      console.log "@.props.unitsData"
#      console.log @.props.unitsData
      selectOptions = _.map(@.props.unitsData, (unit) ->
        UnitOption(unit)
      )
      R.select(
        {
          name: "favourite_unit_id",
          className: "#{ELEMENT_CLASS}__select js-select2"
          onChange: @selectUnitOnTv
        },
        R.option(
          {
            selected: "selected"
          },
          @PLACEHOLDER_VALUE
        )
        {selectOptions}
      )
