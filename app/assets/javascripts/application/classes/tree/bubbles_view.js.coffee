# Handles bubbles display and interaction
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
# @todo implement dispatcher role check
# @todo refactor it:
#   remove all debug stuff
#   rename private methods
#   convert functions to methods
#   refactor comments
class @.app.BubblesView
  constructor: (@treeContainer) ->
    # On unit bubble interaction receive its data
    # @note TEMPORARY METHODS FOR DEBUG REMOVE THEM LATER
    PubSub.subscribe('unit.bubble.create', @receiveCreatedBubble)
    PubSub.subscribe('unit.bubble.destroy', @receiveDestroyedBubble)

    # Starts listening to websockets
    new window.app.bubbleCreateNotification("/broadcast/unit/bubble/create")
    new window.app.bubbleDestroyNotification("/broadcast/unit/bubble/destroy")

#    if $(".js-is-dispatcher").length > 0
      # On add bubble click open form
    $(document).on "click", ".js-bubble-add", @openModalToCreateBubble


  # Reloads bubbles
  # @note is triggered on bubbles model load in units_page e.g.
  # @note this model is located at models/bubbles.js
  # @param allNestedBubblesModelJSON [JSON]
  refreshBubbles:(allNestedBubblesModelJSON) =>
#    console.log 'bubbles model synced. showing bubbles now'
#    console.log "allNestedBubblesModelJSON"
#    console.log allNestedBubblesModelJSON
    @treeContainer.jstree("refresh", true)

    # On reload/open tree node display bubbles
    @treeContainer.off 'open_node.jstree load_node.jstree'
    @treeContainer.on 'open_node.jstree load_node.jstree', =>
      @_showBubbles(allNestedBubblesModelJSON)


  # Shows bubbles for visible nodes
  # @note is triggered in refreshBubbles
  # @param allNestedBubblesModelJSON [JSON]
  _showBubbles:(allNestedBubblesModelJSON) =>
    visibleNodes = $(".jstree-node")
    visibleNodesIds = _.map(visibleNodes, (node)->
      node.id
    )
#      console.log "visibleNodesIds"
#      console.log visibleNodesIds

    visibleNodesIds.forEach(@_createInteractiveContainer)

    visibleNestedBubblesJSON = []
    # Filters only visible nodes to operate with nested bubbles
    # Result will be smth like this:
    #   [{id_here: {0:{count:2, name: "work"}, 2: {}}},{}]
    _getBubblesForUnitId = (unitId) ->
      _.filter(allNestedBubblesModelJSON, (model)->
        if unitId of model
          visibleNestedBubblesJSON.push(model)
      )

    visibleNodesIds.forEach(_getBubblesForUnitId)
#      console.log "visibleNestedBubblesJSON"
#      console.log visibleNestedBubblesJSON
    visibleNestedBubblesJSON.forEach(@_showBubblesForNode)


  # Creates interactive container for a unit which will contain all bubbles and + btn
  # @note is called at _showBubbles for each node
  # @param unitId [Uuid]
  _createInteractiveContainer: (unitId) =>
    $nodeToAddBubblesTo = @treeContainer.find($("#" + unitId))

    $nodeToAddBubblesTo.find(".js-node-interactive-container").remove()
    $nodeToAddBubblesTo.find("> a")[0]
      .appendChild(@_interactiveContainer(unitId))


  # Returns a container for all bubbles and + btn
  # @param unitId [Uuid]
  # @return [DOM] interactive container
  # @note is called in _createInteractiveContainer
  _interactiveContainer: (unitId) =>
    interactiveContainer = document.createElement('div')
    interactiveContainer.className = "js-node-interactive-container"

    # If current user can add bubbles
#    if $(".js-is-dispatcher").length > 0
    interactiveContainer.appendChild(@_addBubbleBtn(unitId))

    return interactiveContainer


  # Creates a button which opens a form to add bubbles to a unit
  # @param unitId [Integer] id of this node
  # @return [DOM] button
  # @note is called at _interactiveContainer
  _addBubbleBtn: (unitId) =>
#    console.log "in createAddBubbleBtn..."
    bubbleAddBtn = document.createElement('span')
    bubbleAddBtn.className = "badge badge-green js-bubble-add"
    bubbleAddBtn.title = "Добавить"
    bubbleAddBtn.setAttribute("data-unit-id", unitId)
    bubbleAddBtn.innerHTML = "+"

    return bubbleAddBtn


  # Creates all bubbles for a node
  # @param nestedBubbleJSON [JSON]
  # @note is called at _showBubbles for each node
  _showBubblesForNode: (nestedBubbleJSON) =>
#    console.log "nestedBubbleJSON"
#    console.log nestedBubbleJSON

    # Creates interactive container for each node
    for unitId, groupedNestedBubblesJSON of nestedBubbleJSON
#      console.log "unitId"
#      console.log unitId
#      console.log "groupedNestedBubblesJSON"
#      console.log groupedNestedBubblesJSON

      $nodeToAddBubblesTo = @treeContainer.find($("#" + unitId))
      interactiveContainer = $nodeToAddBubblesTo.find(".js-node-interactive-container")[0]
      interactiveContainer.appendChild(@_bubblesContainerForUnit(unitId, groupedNestedBubblesJSON))


  # Creates containers for each bubble type of 1 unit
  # @param unitId [Uuid]
  # @param groupedNestedBubblesJSON [JSON]
  # @return [DOM] all bubbles container
  # @note is called at _showBubblesForNode
  _bubblesContainerForUnit: (unitId, groupedNestedBubblesJSON) =>
#    console.log "in createBubblesContainer..."
#    console.log "groupedNestedBubblesJSON"
#    console.log groupedNestedBubblesJSON
    bubblesContainer = document.createElement('div')
    bubblesContainer.className = "js-node-bubbles-container"

    # For each type create a bubble container
    for bubblesTypeInteger, nestedBubbleJSON of groupedNestedBubblesJSON
#      console.log "bubblesTypeInteger"
#      console.log bubblesTypeInteger
#      console.log "nestedBubbleJSON"
#      console.log nestedBubbleJSON
      bubblesContainer.appendChild(@_oneBubbleContainer(unitId, bubblesTypeInteger, nestedBubbleJSON))

    return bubblesContainer


  # Returns a new bubble container for certain bubble type
  # @note is called at _bubblesContainerForUnit for each bubble type
  # @param unitId [Uuid]
  # @param bubblesTypeInteger [Integer]
  # @param nestedBubbleJSON [JSON]
  # @return [DOM] normal bubble container
  _oneBubbleContainer: (unitId, bubblesTypeInteger, nestedBubbleJSON) =>
#    console.log "in createNormalBubbleContainer..."
#    console.log "bubblesTypeInteger"
#    console.log bubblesTypeInteger
    normalBubbleContainer = document.createElement('span')
    normalBubbleContainer.className = "badge badge-grey-darker js-bubble-open unit-bubble-type-#{bubblesTypeInteger}"
    normalBubbleContainer.id = "js-bubble-of-unit-#{unitId}-of-type-#{bubblesTypeInteger}"
    normalBubbleContainer.innerHTML = nestedBubbleJSON.count

    # If there isn't a popover for this bubble already create one
    if $(".js-node-popover-container[data-unit-id=#{unitId}][data-bubble-type=#{bubblesTypeInteger}]").length == 0
      $(".popover-backdrop")[0].appendChild(@_bubblesPopoverContainer(unitId, bubblesTypeInteger, nestedBubbleJSON))

    return normalBubbleContainer


  # Returns a new bubble popover container for certain bubble type
  # @param unitId [Uuid]
  # @param bubblesTypeInteger [Integer]
  # @param nestedBubbleJSON [JSON]
  # @note is called at _oneBubbleContainer
  _bubblesPopoverContainer: (unitId, bubblesTypeInteger, nestedBubbleJSON) =>
    popoverContainer = document.createElement('div')
    popoverContainer.className = "js-node-popover-container"
    popoverContainer.setAttribute("data-unit-id", unitId)
    popoverContainer.setAttribute("data-bubble-type", bubblesTypeInteger)

    allUnitsJSON = _.map(window.models.units.models, (model) ->
      model.attributes
    )
    allBubblesJSON = _.map(window.models.bubbles.models, (model) ->
      model.attributes
    )

    # Collects info about bubbles of this unit and of current type to use in a popover
    bubblesOfThisUnitAndType = _.where(allBubblesJSON, {unit_id: unitId, type_integer: parseInt(bubblesTypeInteger)})
#    console.log "bubblesOfThisUnitAndType"
#    console.log bubblesOfThisUnitAndType

    descendantsOfThisUnit = []
    # Recursive function which collects info about all descendants to get their bubbles later
    getDescendantsOfUnit = (thisUnitId)->
      _.map(_.where(allUnitsJSON, {parent: thisUnitId }), (unit)->
        object = {}
        object['name'] = unit.text
        object['id'] = unit.id
        descendantsOfThisUnit.push object
        getDescendantsOfUnit(unit.id)
      )
    getDescendantsOfUnit(unitId)


    bubblesOfThisUnitDescendantsAndType = []
    # Collects info about bubbles of descendants of this unit of current type to use in a popover
    getThisTypeDescendantsBubblesOfUnit = (unit) ->
      thisUnitBubblesOfThisType = _.where(allBubblesJSON, {unit_id: unit.id, type_integer: parseInt(bubblesTypeInteger)})
      if thisUnitBubblesOfThisType.length > 0
        object = {}
        object['name'] = unit.name
        object['count'] = thisUnitBubblesOfThisType.length
        bubblesOfThisUnitDescendantsAndType.push object

    descendantsOfThisUnit.forEach(getThisTypeDescendantsBubblesOfUnit)
#    console.log "thisTypeDescendantsBubbles"
#    console.log thisTypeDescendantsBubbles

    @_renderBubblesPopoverForThisType(unitId, nestedBubbleJSON.name, bubblesTypeInteger, bubblesOfThisUnitAndType, bubblesOfThisUnitDescendantsAndType, popoverContainer)

    return popoverContainer


  # Renders popover for bubble one bubble type
  # @param unitId [Uuid]
  # @param bubblesTypeInteger [Integer]
  # @param bubblesTypeName [Integer] localized type name to display in popover
  # @param thisUnitAndTypeBubbles [Array of Objects] list of this type bubbles for this unit
  # @param thisTypeDescendantsBubbles [Array of Objects] list of this type bubbles for this unit' descendants
  # @param popoverContainer [DOM] container to render in
  # @param bubblesTypeName [String] name which should be displayed in type popover
  # @note is called in createPopoverContainer
  # note uses bubbles_popover.js.coffee
  # @todo pass localized name of type
  _renderBubblesPopoverForThisType: (unitId, bubblesTypeName, bubblesTypeInteger, thisUnitAndTypeBubbles, thisTypeDescendantsBubbles, popoverContainer) ->

    React.renderComponent(
      window.app.BubblesPopover(
        parent: "#js-bubble-of-unit-#{unitId}-of-type-#{bubblesTypeInteger}"
        bubblesTypeName: bubblesTypeName
        unitId: unitId
        thisUnitAndTypeBubbles: thisUnitAndTypeBubbles
        thisTypeDescendantsBubbles: thisTypeDescendantsBubbles
      ),
      popoverContainer
    )


  # Opens modal with form and resets it
  # @note is triggered on add button click
  # @note is binded on bubbles model load
  openModalToCreateBubble: (e) =>
    unitId = e.target.getAttribute("data-unit-id")
    action = "/units/#{unitId}/bubbles"

    modalContainer = $(".js-bubble-form")
    modalContainer.find(".modal-title").text("Создать баббл")

    $form = modalContainer.find("form")
    $form.find("input[type='submit']").val("Создать баббл")

    $form.attr("action", action)
    $form.attr("method", "post")

    modalContainer.modal()

    $form[0].reset()
    $form.find("select").select2('val', "")


  # @note is triggered on bubble creation
  # @note TEMPORARY METHOD FOR DEBUG
  receiveCreatedBubble: (channel, data)->
    console.log "received created bubble #{data} from #{channel} channel"
    console.log data


  # @note is triggered on bubble update
  # @note TEMPORARY METHOD FOR DEBUG
  receiveUpdatedBubble: (channel, data)->
    console.log "received updated bubble #{data} from #{channel} channel"
    console.log data


  # @note is triggered on bubble destroy
  # @note TEMPORARY METHOD FOR DEBUG
  receiveDestroyedBubble: (channel, data)->
    console.log "received destroyed bubble #{data} from #{channel} channel"
    console.log data