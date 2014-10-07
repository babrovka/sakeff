R = React.DOM

# Handles three-d display as a widget
# @note is created in TvController
# @param controller [TvController]
class window.app.TvView
  controller: null

  constructor: (@controller) ->
    @_renderTv(@controller.$container)
    @_renderButtons(@controller.$container.find("._tv__filter-btns")[0])


  # Renders three-d
  # @note is called on creation
  # @param $container [jQuery DOM] where to render tv
  _renderTv: ($container) =>
    if $container.find('._three-d').length > 0 && $container.find('._three-d canvas').length == 0
      window.app.threeDee = new ThreeDee('._three-d',
        marginHeight: 200,
        marginWidth: 30
      )


  # Renders filter buttons and customizes checkboxes
  # @note is called on creation
  # @param $container [DOM] where to render
  _renderButtons: (container) =>
    React.renderComponent(
      ButtonsContainer(),
      container
    )
    $(document).checkboxes_and_radio()


  ButtonsContainer = React.createClass
    render: ->
      buttonsArray = [
        {name: "ЧП и аварии", class: "_tv__filter-btn--red", htmlName: "emergency"},
        {name: "Работы", class: "_tv__filter-btn--blue", htmlName: "work"},
        {name: "Метки", class: "_tv__filter-btn--green", htmlName: "information"},
      ]
      R.div(
        {},
        [
          R.p(
            {className: "_tv__filter-btns__title"},
            "Показать на карте статусы:"
          ),
          buttonsArray.map (button) ->
            Button(button: button)
        ]
      )


  Button = React.createClass
    handleChange: (e) ->
      checkbox = e.target
      console.log "checkbox"
      console.log checkbox
      toDisplay = $(checkbox).attr("checked") == 'checked'
      typeToShow = checkbox.id
      console.log "toDisplay"
      console.log toDisplay
      console.log "typeToShow"
      console.log typeToShow

      typeNumberToDisplay = switch typeToShow
        when "emergency" then 0
        when "work" then 1
        else 2


      window.app.TreeInterface.displayArray[typeNumberToDisplay] = toDisplay

      for unit in window.app.TreeInterface.getUnitsAttributes()
        window.app.threeDee.bubble_handler(null, unit.id)

      window.app.threeDee.render()


    render: ->
      R.form(
        {
          className: "_tv__filter-btn #{@.props.button.class}"
        },
        [
          R.input(
            {
              type: "checkbox",
              className: "_tv__filter-btn__checkbox",
              name: @.props.button.htmlName,
              id: @.props.button.htmlName,
              onChange: @.handleChange,
              checked: 'checked'
            }
          ),
          R.label(
            {className: "_tv__filter-btn__label", htmlFor: @.props.button.htmlName},
            @.props.button.name
          )
        ]
      )
