# Contains data manipulation methods for bubblesView
# @note is created in BubblesView
class @.app.BubblesController
  constructor: (bubblesView) ->
    @view = bubblesView


  # Filters only visible nodes to operate with nested bubbles
  # @note is called in BubblesView._showBubbles
  # @param nodesIds [Array of String] visible nodes ids
  # @param nestedBubblesJSON [JSON]
  # @return [Object] object with unit id and it's bubbles
  getBubblesForNodesFromJSON: (nodesIds, nestedBubblesJSON) ->
    visibleNestedBubblesJSON = []
    _.each(nodesIds, (unitId) ->
      currentNodeJSON = _.findWhere(nestedBubblesJSON, {unit_id: unitId})
      if currentNodeJSON
        visibleNestedBubblesJSON.push(currentNodeJSON)
    )

    return visibleNestedBubblesJSON


  # Returns info about bubbles of current unit and of current type to use in a popover
  # @note is called in BubblesView._bubblesPopoverContainer
  # @param unitId [String]
  # @param bubblesJSON [JSON]
  # @param typeInteger [Integer] bubble type
  # @return [Array of Objects]
  getBubblesOfUnitAndTypeFromJSON: (unitId, typeInteger, bubblesJSON) ->
    _.where(bubblesJSON, {unit_id: unitId.toLowerCase(), type_integer: parseInt(typeInteger)})


  # Returns info about bubbles of descendants of current unit of current type to use in a popover
  # @note is called in BubblesView._bubblesPopoverContainer
  # @param unitId [String]
  # @param bubblesJSON [JSON]
  # @param typeInteger [Integer] bubble type
  # @return [Array of Objects]
  getThisTypeDescendantsBubblesOfUnit: (unitId, bubblesJSON, typeInteger) =>
    bubblesOfCurrentUnitDescendantsAndType = []
    descendantsOfCurrentUnit = window.app.TreeInterface.getAllDescendantsOfUnit(unitId)

    _.each(descendantsOfCurrentUnit, (unit) =>
      currentUnitBubblesOfThisType = @getBubblesOfUnitAndTypeFromJSON(unit.id, typeInteger, bubblesJSON)

      if currentUnitBubblesOfThisType.length
        bubbleInfoObject = {name: unit.name, bubblesCount: currentUnitBubblesOfThisType.length}
        bubblesOfCurrentUnitDescendantsAndType.push bubbleInfoObject
    )

    return bubblesOfCurrentUnitDescendantsAndType
