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


  # Triggers 3d model select and saves selected unit info
  # @note is called on select change
  selectUnitOnTv: (e) ->
    select = e.target
    value = e.val

    unless value == PLACEHOLDER_VALUE
      @selectedUnit = {
        name: select.options[select.selectedIndex].innerHTML
        id: value
      }
      console.log @selectedUnit
      PubSub.publish('unit.select', @selectedUnit.id)


  #
  createAddBubbleForm: (e) ->
    console.log e
    if @selectedUnit && @selectedUnit.id != PLACEHOLDER_VALUE
      bubbleButton = $(e.target).closest(".#{ELEMENT_CLASS}__button")
      bubbleButtonSelector = ".#{bubbleButton[0].className.split(' ').join('.')}"
      type = {
        name: bubbleButton.data("type-name")
        nameRussian: bubbleButton.data("type-name-russian")
      }
      container_class_name = "add-bubble-form-#{@selectedUnit.id}-#{type.name}"

      unless $(".#{container_class_name}").length
        $container = $("<div class='#{container_class_name}'></div>").appendTo('.popover-backdrop')
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
        BubblesButtons(clickHandler: @createAddBubbleForm)
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
            class: "#{ELEMENT_CLASS}__button--info",
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

    render: ->
      buttons =
        _.map(@.props.addButtonsInfo, (button) =>
          R.div(
            {
              className: "#{ELEMENT_CLASS}__button #{button.class}",
              "data-type-name": button.typeName,
              "data-type-name-russian": button.typeNameRussian,
              onClick: @.props.clickHandler
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
