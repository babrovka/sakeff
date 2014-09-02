# Renders all bubbles popover container for one unit
# @note is created when a node has any bubbles
# @note is called in renderPopoverForNormalBubble of
window.app.BubblesPopover = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    width: 300

  render : ->
    @.renderPopover([
      React.DOM.h3(null,
        "Все инфо бабблы"
      ),
      React.DOM.div(null,
        this.props.bubbles.map (bubble) =>
          BubbleInfoContainer
            unitId: this.props.unitId
            bubble: bubble
      )
    ])


# Container with one bubble info
# @note is rendered in BubblesPopover class for each unit
BubbleInfoContainer = React.createClass
  render: ->
#    console.log "rendering 1 bubble info"
    React.DOM.div(className: "js-bubble-info", [
      React.DOM.h4(className: "js-bubble-text",
        "Сообщение: ", this.props.bubble.text
      )

      React.DOM.h5({className: "js-bubble-type", "data-type-integer": this.props.bubble.type_integer},
        "Тип: ", this.props.bubble.type
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

#      React.DOM.a({
#        href: ""
#        title: "Редактировать"
#        "data-bubble-id": this.props.bubble.id
#        className: "js-edit-unit-bubble-btn btn btn-sea-green"
#      }, "Редактировать")
      ]
    ])