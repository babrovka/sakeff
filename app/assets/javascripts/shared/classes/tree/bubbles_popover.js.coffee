# Renders a bubbles popover container for one unit for one type
# @note is called in _renderBubblesPopoverForThisType in bubbles_view.js.coffee
window.app.BubblesPopover = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    width: 450
    placement: 'right'
    parentClass: 'm-opened-bubble'

  render : ->
    currentObjectName = _.findWhere(window.app.TreeInterface._getUnitsAttributes(), {id: @.props.unitId}).text
    @.renderPopover([
      React.DOM.div(className: "row bubbles-popover",
        React.DOM.div(className: "col-12",
          React.DOM.h3(className: "popover-header",
            "#{@.props.bubblesTypeName} на объекте #{currentObjectName}"
          ),
        ),
        React.DOM.div(className: "col-12",
          React.DOM.div(className: "popover-content",
            React.DOM.h5(className: "total-amount",
              "Всего #{@.props.currentUnitAndTypeBubbles.length}  #{window.app.Pluralizer.pluralizeString(@.props.currentUnitAndTypeBubbles.length, "событие","события","событий")}"
            ),
            React.DOM.div(className: "current-object-bubbles",
              @.props.currentUnitAndTypeBubbles.map (bubble) =>
                CurrentUnitBubblesInfoContainer
                  unitId: @.props.unitId
                  bubble: bubble
            ),
            React.DOM.div(className: "descendant-object-bubbles",
              @.props.currentTypeDescendantsBubbles.map (bubble) =>
                DescendantBubblesInfoContainer
                  descendant: bubble
            ),
          ),
        ),
      ),
    ])


# Container with one bubble info of selected unit
# @note is rendered in BubblesPopover
CurrentUnitBubblesInfoContainer = React.createClass
  render: ->
    React.DOM.div(className: "js-bubble-info bubble-popover-block", [
      React.DOM.p(className: "js-bubble-text",
        @.props.bubble.text
      )

      # If dispatcher, show delete button
      if window.app.CurrentUser.hasPermission("manage_unit_status")
        React.DOM.a({
          href: "/units/#{@.props.unitId}/bubbles/#{@.props.bubble.id}"
          title: "Удалить"
          "data-method": "delete"
          "data-remote": true
          className: "js-delete-unit-bubble-btn label label-red"
        }, "Удалить")
    ])


# Container with one bubble info of selected unit' descendants
# @note is rendered in BubblesPopover
DescendantBubblesInfoContainer = React.createClass
  render: ->
    React.DOM.div(className: "js-bubble-info bubble-popover-block", [
      React.DOM.h5(className: "object-name",
        @.props.descendant.name
      )
      React.DOM.p({className: "js-bubble-type"},
        "#{@.props.descendant.bubblesCount} #{window.app.Pluralizer.pluralizeString(@.props.descendant.bubblesCount, "событие","события","событий")}"
      )
    ])