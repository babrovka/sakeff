# Renders a bubbles popover container for one unit for one type
# @note is called in _renderBubblesPopoverForThisType in bubbles_view.js.coffee
window.app.BubblesPopover = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    width: 300

  render : ->
    @.renderPopover([
      React.DOM.h3(null,
        this.props.bubblesTypeName
      ),
      React.DOM.div(null,
        this.props.thisUnitAndTypeBubbles.map (bubble) =>
          ThisUnitBubblesInfoContainer
            unitId: this.props.unitId
            bubble: bubble
      ),
      React.DOM.div(null,
        this.props.thisTypeDescendantsBubbles.map (bubble) =>
          DescendantBubblesInfoContainer
            bubble: bubble
      ),
    ])


# Container with one bubble info of selected unit
# @note is rendered in BubblesPopover
ThisUnitBubblesInfoContainer = React.createClass
  render: ->
    React.DOM.div(className: "js-bubble-info", [
      React.DOM.h4(className: "js-bubble-text",
        "Сообщение: ", this.props.bubble.text
      )

      # If dispatcher, show edit/delete buttons
#      if $(".js-is-dispatcher").length > 0
      [React.DOM.a({
        href: "units/#{this.props.unitId}/bubbles/#{this.props.bubble.id}"
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
        "Объект: ", this.props.bubble.name
      )
      React.DOM.h5({className: "js-bubble-type"},
        "Количество: ", this.props.bubble.count
      )
    ])