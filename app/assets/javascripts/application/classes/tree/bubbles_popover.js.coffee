# Renders a bubbles popover container for one unit for one type
# @note is called in _renderBubblesPopoverForThisType in bubbles_view.js.coffee
window.app.BubblesPopover = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    width: 300

  render : ->
    @.renderPopover([
      React.DOM.h3(null,
        @.props.bubblesTypeName
      ),
      React.DOM.div(null,
        @.props.currentUnitAndTypeBubbles.map (bubble) =>
          CurrentUnitBubblesInfoContainer
            unitId: @.props.unitId
            bubble: bubble
      ),
      React.DOM.div(null,
        @.props.currentTypeDescendantsBubbles.map (bubble) =>
          DescendantBubblesInfoContainer
            descendant: bubble
      ),
    ])


# Container with one bubble info of selected unit
# @note is rendered in BubblesPopover
CurrentUnitBubblesInfoContainer = React.createClass
  render: ->
    React.DOM.div(className: "js-bubble-info", [
      React.DOM.h4(className: "js-bubble-text",
        "Сообщение: ", @.props.bubble.text
      )

      # If dispatcher, show edit/delete buttons
#      if $(".js-is-dispatcher").length > 0
      [React.DOM.a({
        href: "/units/#{@.props.unitId}/bubbles/#{@.props.bubble.id}"
        title: "Удалить"
        "data-method": "delete"
        "data-remote": true
        className: "js-delete-unit-bubble-btn btn btn-red-d"
      }, "Удалить")
      ]
    ])


# Container with one bubble info of selected unit' descendants
# @note is rendered in BubblesPopover
DescendantBubblesInfoContainer = React.createClass
  render: ->
    React.DOM.div(className: "js-bubble-info", [
      React.DOM.h4(className: "js-bubble-text",
        "Название объекта: ", @.props.descendant.name
      )
      React.DOM.h5({className: "js-bubble-type"},
        "Количество: ", @.props.descendant.bubblesCount
      )
    ])