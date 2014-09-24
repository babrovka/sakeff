# Contains data manipulation methods for bubblesView
class @.app.BubblesController
  constructor: (bubblesView) ->
    @view = bubblesView

  # Filters only visible nodes to operate with nested bubbles
  # @return [Object] object with unit id and it's bubbles
  getBubblesForNodesFromJSON: (nodesIds, bubblesJSON) ->
    visibleNestedBubblesJSON = []
    _.each(nodesIds, (unitId) ->
      currentNodeJSON = _.findWhere(bubblesJSON, {unit_id: unitId})
      if currentNodeJSON
        visibleNestedBubblesJSON.push(currentNodeJSON)
    )

    return visibleNestedBubblesJSON


  # Recursive function which collects info about all descendants to get their bubbles later
  getAllDescendantsOfUnitFromJSON: (unitId, unitsJSON) =>
    descendantsOfThisUnit = []
    @_passDescendantsOfUnitFromJSONToArray(unitId, unitsJSON, descendantsOfThisUnit)

    return descendantsOfThisUnit


  # Collects info about bubbles of descendants of current unit of current type to use in a popover
  getThisTypeDescendantsBubblesOfUnit: (unitId, unitsJSON, bubblesJSON, typeInteger) =>
    bubblesOfCurrentUnitDescendantsAndType = []
    descendantsOfCurrentUnit = @getAllDescendantsOfUnitFromJSON(unitId, unitsJSON)

    _.each(descendantsOfCurrentUnit, (unit) =>
      currentUnitBubblesOfThisType = @getBubblesOfUnitAndTypeFromJSON(unit.id, typeInteger, bubblesJSON)

      if currentUnitBubblesOfThisType.length
        bubbleInfoObject = {name: unit.name, bubblesCount: currentUnitBubblesOfThisType.length}
        bubblesOfCurrentUnitDescendantsAndType.push bubbleInfoObject
    )

    return bubblesOfCurrentUnitDescendantsAndType


  # Collects info about bubbles of current unit and of current type to use in a popover
  getBubblesOfUnitAndTypeFromJSON: (unitId, typeInteger, bubblesJSON) ->
    _.where(bubblesJSON, {unit_id: unitId.toLowerCase(), type_integer: parseInt(typeInteger)})


  # private

  _passDescendantsOfUnitFromJSONToArray: (unitId, unitsJSON, resultArray) =>
    parents = _.where(unitsJSON, {parent: unitId })
    _.map(parents, (unit) =>
      unitInfoObject = {name: unit.text, id: unit.id}
      resultArray.push unitInfoObject
      @_passDescendantsOfUnitFromJSONToArray(unitInfoObject.id, unitsJSON, resultArray)
    )
