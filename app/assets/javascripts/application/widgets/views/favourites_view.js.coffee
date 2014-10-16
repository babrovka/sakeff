R = React.DOM
ELEMENT_CLASS = "_favourites"
PLACEHOLDER_VALUE = "Выберите объект"

# Favourite units interface
# @note is created in window.app.widgets.FavouritesController
# @param unitsData [JSON] state with units model JSON
@.app.widgets.FavouritesView = React.createClass
  selectedUnit: null

  getInitialState: ->
    {
      unitsData: []
    }


  getDefaultProps: ->
    {
      addButtonsInfo: [
        {
          class: "#{ELEMENT_CLASS}__button--emergency",
          iconClass: "fa-exclamation-triangle",
          typeName: "emergency",
          typeNameRussian: "ЧП и аварии"
        },
        {
          class: "#{ELEMENT_CLASS}__button--work",
          iconClass: "fa-wrench",
          typeName: "work",
          typeNameRussian: "Работы"
        },
        {
          class: "#{ELEMENT_CLASS}__button--information",
          iconClass: "fa-bookmark",
          typeName: "information",
          typeNameRussian: "Информация"
        },
        {
          class: "#{ELEMENT_CLASS}__button--show pull-right"
          iconClass: "fa-crosshairs"
        }
      ]
    }

  # Triggers 3d model select and saves selected unit info
  # @note is called on select change
  # @todo separate it into 2 methods
  selectUnitOnTv: (e) ->
    $(".add-bubble-form").remove()
    unitId = e.val

    unless unitId == PLACEHOLDER_VALUE
      select = e.target
      @selectedUnit = {
        name: select.options[select.selectedIndex].innerHTML
        id: unitId
      }

      # Filter out only bubble creation buttons
      buttons = _.filter(@.props.addButtonsInfo, (buttonInfo)->
        buttonInfo.typeName
      )
      # Create popover for each bubble
      _.map buttons, @createAddBubbleForm

      PubSub.publish('unit.select', unitId)


  # Creates a popover for bubble
  # @param buttonInfo [Object]
  createAddBubbleForm: (buttonInfo) ->
    bubbleButtonSelector = ".#{buttonInfo.class}[data-type-name='#{buttonInfo.typeName}']"
    type = {
      name: buttonInfo.typeName
      nameRussian: buttonInfo.typeNameRussian
    }

    popoverClass = "add-bubble-form add-bubble-form-#{@selectedUnit.id}-#{type.name}"

    unless $(".#{popoverClass}").length
      $container = $("<div class='#{popoverClass}'></div>").appendTo('.popover-backdrop')
      React.renderComponent(
        window.NewTreeBubblePopover(
          type: type
          parent : bubbleButtonSelector
          unitId: @selectedUnit.id
          unitName: @selectedUnit.name
          placement: 'right'
          width: 500
        ),
        $container[0]
      )


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
        BubblesButtons(
          addButtonsInfo: @.props.addButtonsInfo
        )
      ]
    )


  # All bubbles buttons
  # @note is rendered in main render
  BubblesButtons = React.createClass
    render: ->
      buttons =
        _.map(@.props.addButtonsInfo, (button) =>
          R.div(
            {
              className: "#{ELEMENT_CLASS}__button #{button.class}",
              "data-type-name": button.typeName,
              "data-type-name-russian": button.typeNameRussian
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
    getDefaultProps : ->
      unitsData: null

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
