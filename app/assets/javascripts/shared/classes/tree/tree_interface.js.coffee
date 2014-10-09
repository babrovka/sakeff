# Handles connection between 3d and tree
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
  # @return [Array of Integer]
  # @example
  #   window.app.TreeInterface.getNumberOfAllBubblesForUnitAndDescendants("b58cfaeb-2299-4875-9d40-0b08a1059eae")
  #     = [2, 1, 0]
  getNumberOfAllBubblesForUnitAndDescendants: (unitId) ->
    resultArray = [0,0,0]
    nestedBubblesAttributes = @getNestedBubblesAttributes()
    currentUnitNestedBubbles =  _.findWhere(nestedBubblesAttributes,
      {unit_id: unitId}
    )

    # If current unit and its descendants have got any bubbles
    if currentUnitNestedBubbles
      typeInteger = 0
      while typeInteger < resultArray.length
        bubblesOfCertainType = currentUnitNestedBubbles.bubbles[typeInteger]
        # If it's okay to display any bubbles of this type and there are any
        if bubblesOfCertainType && window.app.TreeInterface.displayArray[typeInteger]
          resultArray[typeInteger] += parseInt bubblesOfCertainType.count
        typeInteger += 1

    return resultArray


  # Defines which types of bubbles should be displayed on 3d
  # @note is changed on TvView changeFilters
  # @note is used in @getNumberOfAllBubblesForUnitAndDescendants
  displayArray: [true, true, true]


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
  getModelURLByUnitId: (unit_id) ->
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
  # @return [Array of Objects] JSON structure of all bubbles
  getBubblesAttributes: ->
    JSON.parse(JSON.stringify(window.models.bubbles.models))


  # Returns nested bubbles model attributes
  # @note is called in getNumberOfBubblesForUnit
  # @return [Array of Objects] JSON structure of all bubbles
  getNestedBubblesAttributes: ->
    JSON.parse(JSON.stringify(window.models.nestedBubbles.models))


  # Gets all descendants of unit
  # @note is called in BubblesController.getThisTypeDescendantsBubblesOfUnit
  # @param unitId [String]
  # @return [Array of Objects]
  getAllDescendantsOfUnit: (unitId) ->
    descendantsOfThisUnit = []
    @_passDescendantsOfUnitFromJSONToArray(unitId, descendantsOfThisUnit)

    return descendantsOfThisUnit


  # private

  # Recursive function which passes info about unit descendant to array
  # @note is called in getAllDescendantsOfUnit
  # @param unitId [String]
  # @param resultArray [Array of Objects] in which all objects will be stored
  _passDescendantsOfUnitFromJSONToArray: (unitId, resultArray) ->
    parents = _.where(@getUnitsAttributes(), {parent: unitId })
    _.map(parents, (unit) =>
      unitInfoObject = {name: unit.text, id: unit.id}
      resultArray.push unitInfoObject
      @_passDescendantsOfUnitFromJSONToArray(unitInfoObject.id, resultArray)
    )
