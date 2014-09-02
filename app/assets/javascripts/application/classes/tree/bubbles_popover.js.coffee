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
        this.props.bubblesTypeName
      ),
      React.DOM.div(null,
        this.props.thisUnitAndTypeBubbles.map (bubble) =>
          ThisUnitBubbleInfoContainer
            unitId: this.props.unitId
            bubble: bubble
      ),
      React.DOM.div(null,
        this.props.thisTypeDescendantsBubbles.map (bubble) =>
          DescendantBubbleInfoContainer
            bubble: bubble
      ),
    ])


# Container with one bubble info
# @note is rendered in BubblesPopover class for each unit
ThisUnitBubbleInfoContainer = React.createClass
  render: ->
#    console.log "rendering 1 bubble info"
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

#      React.DOM.a({
#        href: ""
#        title: "Редактировать"
#        "data-bubble-id": this.props.bubble.id
#        className: "js-edit-unit-bubble-btn btn btn-sea-green"
#      }, "Редактировать")
      ]
    ])


# Container with one bubble info
# @note is rendered in BubblesPopover class for each unit
DescendantBubbleInfoContainer = React.createClass
  render: ->
#    console.log "rendering 1 bubble info"
    React.DOM.div(className: "js-bubble-info", [
      React.DOM.h4(className: "js-bubble-text",
        "Объект: ", this.props.bubble.name
      )

      React.DOM.h5({className: "js-bubble-type"},
        "Количество: ", this.props.bubble.count
      )

    ])