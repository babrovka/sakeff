# Handles connection between 3d and tree
# @note is kinda a main controller
@.app.TreeInterface =
  # Returns an array of unit id of given unit parent uuds
  # @param unitId [Uuid] of unit to get parents of
  # @return [Array of Uuid]
  # @example
  #   window.app.TreeInterface.ancestors("b58cfaeb-2299-4875-9d40-0b08a1059eae")
  ancestors: (unitId) ->
    ids = []
    modelAttributes = @_getUnitsAttributes()

    currentId = unitId
    while currentId != "#"
      currentId = _.findWhere(modelAttributes, {id: currentId}).parent
      ids.push currentId if currentId != "#"
    ids


  # Returns number of bubbles of certain type
  # @param unitId [Uuid] id of unit
  # @todo implement it
  # @example
  #   window.app.TreeInterface.numBubbles("b58cfaeb-2299-4875-9d40-0b08a1059eae")
  numBubbles: (unitId) ->
    return _.random(0,10)


  # Returns root element id
  # @example
  #   window.app.TreeInterface.getRootUnitId()
  # @return [String] Uuid
  getRootUnitId: ->
    modelAttributes = @_getUnitsAttributes()
    _.findWhere(modelAttributes, {parent: "#"}).id


  # Gets link to a unit model file name
  # @param unit_id [Uuid]
  # @return [String]
  # @example
  #   window.app.TreeInterface.getModelURLByUnitId("b58cfaeb-2299-4875-9d40-0b08a1059eae")
  getModelURLByUnitId:(unit_id) ->
    modelAttributes = @_getUnitsAttributes()
    model_filename = _.findWhere(modelAttributes, {id: unit_id}).model_filename
    if model_filename
      return "/models/#{model_filename}"
    else
      return null


  # private

  # Returns units model attributes
  # @note is called in ancestors and getRootUnitId
  # @return [Array of Objects] JSON structure of all units
  _getUnitsAttributes: ->
    _.map(window.models.units.models, (model) ->
      model.attributes
    )
