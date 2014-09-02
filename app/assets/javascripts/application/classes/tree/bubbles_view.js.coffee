# Handles bubbles display
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
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


  # Shows bubbles on bubbles load
  # @note this model is located at models/bubbles.js
  # @todo it should show a create bubble button for all bubbles and only after that filter bubbles etc
  showBubbles:(allNestedBubblesModelJSON) =>
    console.log 'bubbles model synced. showing bubbles now'
#    console.log "allNestedBubblesModelJSON"
#    console.log allNestedBubblesModelJSON
    @treeContainer.jstree("refresh", true)

    # On reload/open tree node display bubbles
    @treeContainer.off 'open_node.jstree load_node.jstree'
    @treeContainer.on 'open_node.jstree load_node.jstree', =>
      visibleNodes = $(".jstree-node")
      visibleNodesIds = _.map(visibleNodes, (node)->
        node.id
      )
#      console.log "visibleNodesIds"
#      console.log visibleNodesIds

      # Firstly, we create an interactive container for each node. Other there we add a + button and then for each visible nested bubbles json we append bubble containers to interactive containers
      visibleNodesIds.forEach(@prepareInteractiveContainer)

      visibleNestedBubblesJSON = []

      # Filters only visible nodes to operate with nested bubbles
      # Result will be smth like this:
      #   [{id_here: {0:{count:2, name: "work"}, 2: {}}},{}]
      # @todo refactor it to a simple filter
      getBubblesForUnitId = (unitId) ->
        _.each(allNestedBubblesModelJSON, (model)->
          if unitId of model
            visibleNestedBubblesJSON.push(model)
        )

      visibleNodesIds.forEach(getBubblesForUnitId)
#      console.log "visibleNestedBubblesJSON"
#      console.log visibleNestedBubblesJSON


      visibleNestedBubblesJSON.forEach(@showBubblesForNode)


  # Creates interactive elements for each node
  # @note is called at showInteractiveElementsInTree for each node
  showBubblesForNode: (nestedBubbleJSON) =>
#    console.log "in showInteractiveElementsInNode..."
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
      interactiveContainer.appendChild(@createBubblesContainer(unitId, groupedNestedBubblesJSON))


  # Start creating interactive container for a unit
  prepareInteractiveContainer: (unitId) =>
    $nodeToAddBubblesTo = @treeContainer.find($("#" + unitId))

    $nodeToAddBubblesTo.find(".js-node-interactive-container").remove()
    $nodeToAddBubblesTo.find("> a")[0]
      .appendChild(@createInteractiveContainer(unitId))


  # Creates an interactive container container for a node in which all bubbles and addBubbleBtn are located
  # @param unitJSON [JSON] all data from server for this node
  # @return [DOM] interactive container
  # @note is called in showInteractiveElementsInNode when node is rendered
  createInteractiveContainer: (unitId) =>
#    console.log "in createInteractiveContainer..."
    interactiveContainer = document.createElement('div')
    interactiveContainer.className = "js-node-interactive-container"


    # If dispatcher add plus button
#    if $(".js-is-dispatcher").length > 0
    interactiveContainer.appendChild(@createAddBubbleBtn(unitId))

    return interactiveContainer


  # Creates a button which opens a form to add bubbles to a unit
  # @param unitId [Integer] id of this node
  # @return [DOM] button
  # @note is called at createInteractiveContainer when user is dispatcher
  createAddBubbleBtn: (unitId) =>
#    console.log "in createAddBubbleBtn..."
    bubbleAddBtn = document.createElement('span')
    bubbleAddBtn.className = "badge badge-green js-bubble-add"
    bubbleAddBtn.title = "Добавить"
    bubbleAddBtn.setAttribute("data-unit-id", unitId)
    bubbleAddBtn.innerHTML = "+"

    return bubbleAddBtn


  # Creates a container for all bubbles
  # @param unitJSON [JSON] all data from server for one node
  # @return [DOM] all bubbles container
  # @note is called at createInteractiveContainer
  createBubblesContainer: (unitId, groupedNestedBubblesJSON) =>
#    console.log "in createBubblesContainer..."
#    console.log "groupedNestedBubblesJSON"
#    console.log groupedNestedBubblesJSON
    bubblesContainer = document.createElement('div')
    bubblesContainer.className = "js-node-bubbles-container"

    for bubblesTypeInteger, nestedBubbleJSON of groupedNestedBubblesJSON
#      console.log "bubblesTypeInteger"
#      console.log bubblesTypeInteger
#      console.log "nestedBubbleJSON"
#      console.log nestedBubbleJSON
      bubblesContainer.appendChild(@createBubbleContainer(unitId, bubblesTypeInteger, nestedBubbleJSON))


    return bubblesContainer


  # Creates a bubble container for each type
  # @param unitJSON [JSON] all data from server for one node
  # @return [DOM] normal bubble container
  # @note is called at createInteractiveContainer when node has any bubbles
  createBubbleContainer: (unitId, bubblesTypeInteger, nestedBubbleJSON) =>
#    console.log "in createNormalBubbleContainer..."
#    console.log "bubblesTypeInteger"
#    console.log bubblesTypeInteger
    normalBubbleContainer = document.createElement('span')
    normalBubbleContainer.className = "badge badge-grey-darker js-bubble-open unit-bubble-type-#{bubblesTypeInteger}"
    # Used for actions
#    normalBubbleContainer.setAttribute("data-unit-id", unitId)
    normalBubbleContainer.id = "js-bubble-of-unit-#{unitId}-of-type-#{bubblesTypeInteger}"
#    normalBubbleContainer.setAttribute("data-bubble-type", bubblesType)
    normalBubbleContainer.innerHTML = nestedBubbleJSON.count

    # If there isn't a popover for this bubble already create one
    if $(".js-node-popover-container[data-unit-id=#{unitId}][data-bubble-type=#{bubblesTypeInteger}]").length == 0
#      console.log "creating popover for unit"
      $(".popover-backdrop")[0].appendChild(@createPopoverContainer(unitId, bubblesTypeInteger, nestedBubbleJSON))

    return normalBubbleContainer


  # Create popover container for certain type of bubbles for certain unit
  # @param unitJSON [JSON] all data from server for one node
  # @note is called at createNormalBubbleContainer
  createPopoverContainer: (unitId, bubblesTypeInteger, nestedBubbleJSON) =>
#    console.log "in createPopoverContainer..."
#    console.log "nestedBubbleJSON"
#    console.log nestedBubbleJSON
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


#    console.log "allBubblesJSON"
#    console.log allBubblesJSON

    # Collects info about bubbles of this unit of current type to use in a popover
    bubblesOfThisUnitAndType = _.where(allBubblesJSON, {unit_id: unitId, type_integer: parseInt(bubblesTypeInteger)})
#    console.log "thisUnitAndTypeBubbles"
#    console.log thisUnitAndTypeBubbles

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
#    console.log "descendants"
#    console.log descendants


    bubblesOfThisUnitDescendantsAndType = []
    # Collects info about bubbles of descendants of this unit of current type to use in a popover
    getThisTypeDescendantsBubblesOfUnit = (unit) ->
      thisUnitBubblesOfThisType = _.where(allBubblesJSON, {unit_id: unit.id, type_integer: parseInt(bubblesTypeInteger)})
#      console.log "thisUnitBubblesOfThisType"
#      console.log thisUnitBubblesOfThisType
      if thisUnitBubblesOfThisType.length > 0
        object = {}
        object['name'] = unit.name
        object['count'] = thisUnitBubblesOfThisType.length
        bubblesOfThisUnitDescendantsAndType.push object

    descendantsOfThisUnit.forEach(getThisTypeDescendantsBubblesOfUnit)
#    console.log "thisTypeDescendantsBubbles"
#    console.log thisTypeDescendantsBubbles

    @renderBubblesPopoverForThisType(unitId, nestedBubbleJSON.name, bubblesTypeInteger, bubblesOfThisUnitAndType, bubblesOfThisUnitDescendantsAndType, popoverContainer)

    return popoverContainer


  # Renders popover for normal bubble
  # @param unitJSON [JSON] all data from server for one node
  # @param popoverContainer [DOM] container to render in
  # @param bubblesTypeName [String] name which should be displayed in type popover
  # @note is called in createPopoverContainer
  renderBubblesPopoverForThisType: (unitId, bubblesTypeName, bubblesTypeInteger, thisUnitAndTypeBubbles, thisTypeDescendantsBubbles, popoverContainer) ->
#    console.log "in renderPopoverForNormalBubble..."

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


  # Opens modal with form on add button click and resets it
  # @note is binded on page load
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