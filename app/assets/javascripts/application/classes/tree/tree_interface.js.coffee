# Handles connection between 3d and tree
# @note is kinda a main controller
@.app.TreeInterface = {}

# Returns an array of unit id of given unit parent uuds
# @param unitId [Uuid] of unit to get parents of
# @return [Array of Uuid]
@.app.TreeInterface.ancestors = (unitId) ->
  ids = []
  modelAttributes = _.map(window.models.units.models, (model) ->
    model.attributes
  )

  currentId = unitId
  while currentId != "#"
    currentId = _.findWhere(modelAttributes, {id: currentId}).parent
    ids.push currentId if currentId != "#"

  ids


# Returns number of bubbles of certain type
# @param unitId [Uuid] id of unit
# @param bubbleType [Integer] numeric type of unit bubbles
# @todo implement it
@.app.TreeInterface.numBubbles = (unitId, bubbleType) ->
  return _.rand(0,10)