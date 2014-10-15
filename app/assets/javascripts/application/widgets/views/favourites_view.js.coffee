R = React.DOM
ELEMENT_CLASS = "_favourites"
PLACEHOLDER_VALUE = "Выберите объект"

# Favourite units interface
# @note is created in window.app.widgets.FavouritesController
# @param unitsData [JSON] state with units model JSON
@.app.widgets.FavouritesView = React.createClass
  getInitialState: ->
    {
      unitsData: []
    }


  # Triggers 3d model select
  # @note is called on select change
  selectUnitOnTv: (e) ->
    unit_id = e.val
    unless unit_id == PLACEHOLDER_VALUE
      PubSub.publish('unit.select', unit_id)


  # On first render assigns select change
  componentDidMount: ->
    $(document).on "change", ".#{ELEMENT_CLASS}__select", @selectUnitOnTv


  # On render turns on select2
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

    favouriteForm =
      if @.state.unitsData.length
        FavSelect(unitsData: @.state.unitsData)
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


  # All bubbles buttons
  # @note is rendered in main render
  BubblesButtons = React.createClass
    getDefaultProps: ->
      {
        addButtonsInfo: [
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
      }

    render: ->
      buttons =
        _.map(@.props.addButtonsInfo, (button) ->
          R.div(
            {
              className: "#{ELEMENT_CLASS}__button #{button.class}",
              "data-type-integer": button.typeInteger
            },
            R.i(
              {
                className: "fa #{button.iconClass}"
              }
            )
          )
        )

      R.div(
        {
          className: "#{ELEMENT_CLASS}__buttons"
        },
        buttons
      )


  # Favourite units select
  # @note is rendered in main render
  # @param unitsData [JSON]
  FavSelect = React.createClass
    render: ->
      unitsOptions =
        _.map(@.props.unitsData, (unit) ->
          R.option(
            {
              value: unit.id
            },
            unit.text
          )
        )

      R.select(
        {
          name: "favourite_unit_id",
          className: "#{ELEMENT_CLASS}__select js-select2",
          defaultValue: PLACEHOLDER_VALUE
        },
        [
          R.option(
            {},
            PLACEHOLDER_VALUE
          ),
          unitsOptions
        ]
      )
