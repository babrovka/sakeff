# Handles bubbles display
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
# @todo refactor it and remove all debug stuff
class @.app.BubblesView
  constructor: (@treeContainer) ->
    # On unit bubble interaction receive its data
    # @note TEMPORARY METHODS FOR DEBUG
    PubSub.subscribe('unit.bubble.create', @receiveCreatedBubble)
#    PubSub.subscribe('unit.bubble.update', @receiveUpdatedBubble)
    PubSub.subscribe('unit.bubble.destroy', @receiveDestroyedBubble)

    # Starts listening to websockets
    new window.app.bubbleCreateNotification("/broadcast/unit/bubble/create")
#    new window.app.bubbleUpdateNotification("/broadcast/unit/bubble/update")
    new window.app.bubbleDestroyNotification("/broadcast/unit/bubble/destroy")

#    if $(".js-is-dispatcher").length > 0
      # On add bubble click open form
    $(document).on "click", ".js-bubble-add", @openModalToCreateBubble

#    # On edit bubble click open form
#    $(document).on "click", ".js-edit-unit-bubble-btn", @openModalToEditBubble


  # Shows bubbles on bubbles load
  # @note this model is located at models/bubbles.js
  fetchBubbles:(models) =>
    console.log 'bubbles model synced. showing bubbles now'
#    console.log models
#    models = _.map(notSortedModels, (model) ->
#      model.attributes
#    )
    # On tree open or load show all interactive elements
    @treeContainer.jstree("refresh", true)
#      console.log "in fetchBubbles..."
    console.log "models"
    console.log models
    # On reload tree and open node display bubbles
    @treeContainer.off 'open_node.jstree load_node.jstree'
    @treeContainer.on 'open_node.jstree load_node.jstree', =>

      # todo: refactor this
      # todo: take bubble type from first bubble, without making it a key
      visibleNodes = $(".jstree-node")
      visibleNodesIds = _.map(visibleNodes, (node)->
        node.id
      )
      console.log "visibleNodesIds"
      console.log visibleNodesIds


      # Now we need to get all bubbles info for each visible node


      visibleNodesWithGroupedBubbles = []
      # Populates an array with objects with unit id as key and grouped bubbles as value
      getBubblesForUnitId = (unitId) ->
        _.each(models, (model)->
          if unitId of model
            visibleNodesWithGroupedBubbles.push(model)
        )

        # Сначала пройдемся по всем объектам и для каждого их ключа посмотрим, есть


#        groupedBubblesByType = _.groupBy(thisUnitBubbles, 'type_integer')
##          console.log "groupedBubblesByType"
##          console.log groupedBubblesByType
#
#        object = {}
#        object[unitId] = groupedBubblesByType

#          console.log "object"
#          console.log object

      visibleNodesIds.forEach(getBubblesForUnitId)
#      console.log "visibleNodesWithGroupedBubbles"
#      console.log visibleNodesWithGroupedBubbles

      visibleNodesWithGroupedBubbles.forEach(@showInteractiveElementsInNode)

#  # Shows interactive elements in all rendered nodes
#  # @param event [NOT USED]
#  # @param status [Object] jstree loaded objects info
#  # @note is called on jstree load or node open event
#  showInteractiveElementsInTree: (models) =>
#    models.forEach(@showInteractiveElementsInNode)


  # Creates interactive elements for node
  # @note is called at showInteractiveElementsInTree for each node
  # @todo optimize it so it doesn't rerender interactive containers of units which didn't have
  #   their bubbles changed
  showInteractiveElementsInNode: (visibleNodeWithGroupedBubbles) =>
#    console.log "in showInteractiveElementsInNode..."
#    console.log "visibleNodeWithGroupedBubbles"
#    console.log visibleNodeWithGroupedBubbles
    # Для каждого из юнитов мы создаем кнопку добавить и для каждого типа бабблов создать баббл контейнер
    for unitId, bubblesJSON of visibleNodeWithGroupedBubbles
#      console.log "unitId"
#      console.log unitId
#      console.log "bubblesJSON"
#      console.log bubblesJSON

      $nodeToAddBubblesTo = @treeContainer.find($("#" + unitId))
#      console.log "$nodeToAddBubblesTo"
#      console.log $nodeToAddBubblesTo

      $nodeToAddBubblesTo.find(".js-node-interactive-container").remove()
      $nodeToAddBubblesTo
        .find("> a")[0]
          .appendChild(@createInteractiveContainer(unitId, bubblesJSON))

##    console.log "$nodeWithBubble.length"
##    console.log $nodeWithBubble.length
##


  # Creates an interactive container container for a node
  # @param unitJSON [JSON] all data from server for this node
  # @return [DOM] interactive container
  # @note is called in showInteractiveElementsInNode when node is rendered
  createInteractiveContainer: (unitId, bubblesJSON) =>
#    console.log "in createInteractiveContainer..."
    interactiveContainer = document.createElement('div')
    interactiveContainer.className = "js-node-interactive-container"

#    console.log "bubblesJSON"
#    console.log bubblesJSON

    # For each bubble type group create bubbles container
    # Теперь нужно пройтись по всем ключам и значениям, для каждой пары
#    bubblesJSONArray = _.pairs(bubblesJSON)
#    console.log "bubblesJSONArray"
#    console.log bubblesJSONArray
    interactiveContainer.appendChild(@createBubblesContainer(unitId, bubblesJSON))
#    for bubblesType, bubblesJSONArray of bubblesJSON
#      interactiveContainer.appendChild(@createBubblesContainer(bubblesType, bubblesJSONArray))

    # If dispatcher add plus button
#    if $(".js-is-dispatcher").length > 0
    interactiveContainer.appendChild(@createAddBubbleBtn(unitId))

    return interactiveContainer


  # Create a button which adds bubbles to a unit
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


  # Create all bubbles container
  # @param unitJSON [JSON] all data from server for one node
  # @return [DOM] all bubbles container
  # @note is called at createInteractiveContainer
  createBubblesContainer: (unitId, bubblesJSON) =>
#    console.log "in createBubblesContainer..."
#    console.log "bubblesJSON"
#    console.log bubblesJSON
    bubblesContainer = document.createElement('div')
    bubblesContainer.className = "js-node-bubbles-container"
#    bubblesContainer.setAttribute("data-bubble-type", bubblesType)
    for bubblesType, bubbleJSON of bubblesJSON
      bubblesContainer.appendChild(@createNormalBubbleContainer(unitId, bubblesType, bubbleJSON))

#
#    # If any children have any bubbles show an indicator
#    # @todo implement it here from 3rd array of data from server
#    if bubbleJSON.tree_has_bubbles
#      bubblesContainer.appendChild(@createChildrenHasBubblesIndicator())

    return bubblesContainer


  # Create a bubble which will open an all bubbles popover
  # @param unitJSON [JSON] all data from server for one node
  # @return [DOM] normal bubble container
  # @note is called at createInteractiveContainer when node has any bubbles
  createNormalBubbleContainer: (unitId, bubblesType, bubbleJSON) =>
#    console.log "in createNormalBubbleContainer..."
    console.log "bubblesType"
    console.log bubblesType
    normalBubbleContainer = document.createElement('span')
    normalBubbleContainer.className = "badge badge-grey-darker js-bubble-open unit-bubble-type-#{bubblesType}"
#    normalBubbleContainer.setAttribute("data-html", true)
    # Used for actions
    normalBubbleContainer.setAttribute("data-unit-id", unitId)
    normalBubbleContainer.id = "js-bubble-of-unit-#{unitId}-of-type-#{bubblesType}"
    normalBubbleContainer.setAttribute("data-bubble-type", bubblesType)
    normalBubbleContainer.innerHTML = bubbleJSON.count

    # If there isn't a popover for this bubble already create one
    if $(".js-node-popover-container[data-unit-id=#{unitId}][data-bubble-type=#{bubblesType}]").length == 0
#      console.log "creating popover for unit"
      $(".popover-backdrop")[0].appendChild(@createPopoverContainer(unitId, bubblesType, bubbleJSON))

    return normalBubbleContainer


  # Create popover container
  # @param unitJSON [JSON] all data from server for one node
  # @note is called at createNormalBubbleContainer
  createPopoverContainer: (unitId, bubblesType, bubbleJSON) =>
    console.log "in createPopoverContainer..."
    console.log "bubbleJSON"
    console.log bubbleJSON
    popoverContainer = document.createElement('div')
    popoverContainer.className = "js-node-popover-container"
    popoverContainer.setAttribute("data-unit-id", unitId)
    popoverContainer.setAttribute("data-bubble-type", bubblesType)


    allBubblesJSON = _.map(window.models.bubbles.models, (model) ->
      model.attributes
    )

#    console.log "allBubblesJSON"
#    console.log allBubblesJSON
    thisUnitAndTypeBubbles = _.where(allBubblesJSON, {unit_id: unitId, type_integer: parseInt(bubblesType)})
#    console.log "thisUnitAndTypeBubbles"
#    console.log thisUnitAndTypeBubbles

    unitModels = _.map(window.models.units.models, (model) ->
      model.attributes
    )
    bubbleModels = _.map(window.models.bubbles.models, (model) ->
      model.attributes
    )

    descendants = []
    # Recursive function which collects info about all descendants
    getDescendants = (thisUnitId)->
      _.map(_.where(unitModels, {parent: thisUnitId }), (model)->
        object = {}
        object['name'] = model.text
        object['id'] = model.id
        descendants.push object
        getDescendants(model.id)
      )
    getDescendants(unitId)
    if descendants.length > 0
      console.log "descendants"
      console.log descendants


    thisTypeDescendantsBubbles = []

    getBubbles = (unit) ->
      thisUnitBubblesOfThisType = _.where(bubbleModels, {unit_id: unit.id, type_integer: parseInt(bubblesType)})
      console.log "thisUnitBubblesOfThisType"
      console.log thisUnitBubblesOfThisType
      if thisUnitBubblesOfThisType.length > 0
        object = {}
        object['name'] = unit.name
        object['count'] = thisUnitBubblesOfThisType.length
        thisTypeDescendantsBubbles.push object

    descendants.forEach(getBubbles)
    console.log "thisTypeDescendantsBubbles"
    console.log thisTypeDescendantsBubbles


    # First, let's make an array of node ids which are descendants of this unitId with structure {name: "C-1", id: "12312315"}
    # then let's iterate over them and find bubbles from whole bubbles array which have a unitId of that id and type of bubblesType and add count them to thisTypeDescendantsBubbles as objects with result structure

    # result [{name: "C-1", count: 15}]

    @renderPopoverForNormalBubble(unitId, bubbleJSON.name, bubblesType, thisUnitAndTypeBubbles, thisTypeDescendantsBubbles, popoverContainer)

    return popoverContainer


  # Renders popover for normal bubble
  # @param unitJSON [JSON] all data from server for one node
  # @param popoverContainer [DOM] container to render in
  # @note is called in createPopoverContainer
  renderPopoverForNormalBubble: (unitId, bubblesTypeName, bubblesType, thisUnitAndTypeBubbles, thisTypeDescendantsBubbles, popoverContainer) ->
#    console.log "in renderPopoverForNormalBubble..."

    React.renderComponent(
      window.app.BubblesPopover(
        parent: "#js-bubble-of-unit-#{unitId}-of-type-#{bubblesType}"
        bubblesTypeName: bubblesTypeName
        unitId: unitId
        thisUnitAndTypeBubbles: thisUnitAndTypeBubbles
        thisTypeDescendantsBubbles: thisTypeDescendantsBubbles
      ),
      popoverContainer
    )


  # Opens a modal for edit or creation of bubbles
  # Contains shared code for openModalToCreateBubble and openModalToEditBubble
  # @return [jQuery DOM] form
  openUnitBubbleForm: (unitId, action, text, method) ->
    modalContainer = $(".js-bubble-form")
    $form = modalContainer.find("form")

    modalContainer.find(".modal-title").text(text)
    $form.find("input[type='submit']").val(text)

    $form.attr("action", action)
    $form.attr("method", method)

    modalContainer.modal()

    return $form


  # Opens modal with form on add button click and resets it
  # @note is binded on page load
  # @todo combine it with openUnitBubbleForm
  openModalToCreateBubble: (e) =>
    unitId = e.target.getAttribute("data-unit-id")
    action = "/units/#{unitId}/bubbles"

    $form = @openUnitBubbleForm(unitId, action, "Создать баббл", "post")

    $form[0].reset()
    $form.find("select").select2('val', "")


  # Opens modal with form on edit button click and resets it
  # @note is binded on page load
#  openModalToEditBubble: (e) =>
#    e.preventDefault()
#    $this = $(e.target)
#
#    bubbleText = $this.parents(".js-bubble-info").find(".js-bubble-text span:last-child").text()
#    bubbleTypeInteger = $this.parents(".js-bubble-info").find(".js-bubble-type").data("type-integer")
#
#    unitId = $this.parents(".js-node-popover-container").attr("data-unit-id")
#    bubbleId = e.target.getAttribute("data-bubble-id")
#    action = "/units/#{unitId}/bubbles/#{bubbleId}"
#
#    $form = @openUnitBubbleForm(unitId, action, "Редактировать баббл", "patch")
#
#    bubbleTypeSelect = $form.find("#unit_bubble_bubble_type")
#    bubbleType = bubbleTypeSelect.find("option")[bubbleTypeInteger + 1].value
#
#    $form.find("#unit_bubble_bubble_type").select2('val', bubbleType)
#    $form.find("#unit_bubble_comment").val(bubbleText)
#    $form.find("#unit_bubble_id").val(bubbleId)


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