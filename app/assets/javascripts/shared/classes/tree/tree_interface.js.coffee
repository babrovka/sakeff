# Handles connection between 3d and tree
# @note is kinda a main controller
window.app.TreeInterface =
  # Returns an array of unit id of given unit parent uuds
  # @param unitId [Uuid] of unit to get parents of
  # @return [Array of Uuid]
  # @example
  #   window.app.TreeInterface.ancestors("b58cfaeb-2299-4875-9d40-0b08a1059eae")
  ancestors: (unitId) ->
    ids = []
    modelAttributes = @getUnitsAttributes()

    currentId = unitId
    i = 0
    while i < modelAttributes.length
      currentObject = _.findWhere(modelAttributes, {id: currentId})
      if currentObject
        currentId = currentObject.parent
        ids.push currentId if currentId != "#"
      i += 1
    return ids


  # Returns number of bubbles of certain type for unit and its descendants
  # @param unitId [Uuid] id of unit
  # @return [Array of Integer] length = 4
  # @example
  #   window.app.TreeInterface.getNumberOfAllBubblesForUnitAndDescendants("b58cfaeb-2299-4875-9d40-0b08a1059eae")
  #     = [2, 1, 0, 0]
  getNumberOfAllBubblesForUnitAndDescendants: (unitId) ->
    resultArray = [0,0,0,0]
    nestedBubblesAttributes = @getNestedBubblesAttributes()
    currentUnitNestedBubbles =  _.findWhere(nestedBubblesAttributes,
      {unit_id: unitId}
    )

    # If current unit and its descendants have got any bubbles
    if currentUnitNestedBubbles
      typeInteger = 0
      while typeInteger < resultArray.length
        bubblesOfCertainType = currentUnitNestedBubbles.bubbles[typeInteger]
        if bubblesOfCertainType
          resultArray[typeInteger] += bubblesOfCertainType.count
        typeInteger += 1

    return resultArray


  # Returns root element id
  # @example
  #   window.app.TreeInterface.getRootUnitId()
  # @return [String] Uuid
  getRootUnitId: ->
    modelAttributes = @getUnitsAttributes()
    rootObject = _.findWhere(modelAttributes, {parent: "#"})
    return rootObject.id if rootObject


  # Gets link to a unit model file name
  # @param unit_id [Uuid]
  # @return [String]
  # @example
  #   window.app.TreeInterface.getModelURLByUnitId("b58cfaeb-2299-4875-9d40-0b08a1059eae")
  getModelURLByUnitId:(unit_id) ->
    modelAttributes = @getUnitsAttributes()
    currentUnit = _.findWhere(modelAttributes, {id: unit_id})
    if currentUnit && currentUnit.model_filename
      return "/models/#{currentUnit.model_filename}"
    else
      return null


  # Returns units model attributes
  # @note is called in ancestors and getRootUnitId
  # @return [Array of Objects] JSON structure of all units
  getUnitsAttributes: ->
    JSON.parse(JSON.stringify(window.models.units.models))


  # Returns bubbles model attributes
  # @note is called nowhere atm
  # @todo use these methods in other classes to avoid code duplication
  # @return [Array of Objects] JSON structure of all bubbles
  getBubblesAttributes: ->
    JSON.parse(JSON.stringify(window.models.bubbles.models))


  # Returns nested bubbles model attributes
  # @note is called in getNumberOfBubblesForUnit
  # @return [Array of Objects] JSON structure of all bubbles
  getNestedBubblesAttributes: ->
    JSON.parse(JSON.stringify(window.models.nestedBubbles.models))
