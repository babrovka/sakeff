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
    PubSub.subscribe('unit.bubble.update', @receiveUpdatedBubble)
    PubSub.subscribe('unit.bubble.destroy', @receiveDestroyedBubble)

    if $(".js-is-dispatcher").length > 0
      # On add bubble click open form
      $(document).on "click", ".js-bubble-add", @openModalToCreateBubble

      # On edit bubble click open form
      $(document).on "click", ".js-edit-unit-bubble-btn", @openModalToEditBubble


  # Shows bubbles on bubbles load
  # @note this model is located at models/bubbles.js
  fetchBubbles:(__method, models) =>
    console.log 'bubbles model synced. showing bubbles now'
    # On tree open or load show all interactive elements
    @treeContainer.jstree("refresh", true)
#      console.log "in fetchBubbles..."
#      console.log "models"
#      console.log models
    # On reload tree and open node display bubbles
    @treeContainer.off 'open_node.jstree load_node.jstree'
    @treeContainer.on 'open_node.jstree load_node.jstree', =>

      # todo: refactor this
      # todo: take bubble type from first bubble, without making it a key
      visibleNodes = $(".jstree-node")
      visibleNodesIds = _.map(visibleNodes, (node)->
        node.id
      )
#        console.log "visibleNodesIds"
#        console.log visibleNodesIds

      visibleNodesWithGroupedBubbles = []

      # Populates an array with objects with unit id as key and grouped bubbles as value
      getBubblesForUnitId = (unitId) ->
        thisUnitBubbles = _.where(models, {unit_id: unitId})
#          console.log "thisUnitBubbles"
#          console.log thisUnitBubbles

        groupedBubblesByType = _.groupBy(thisUnitBubbles, 'type_integer')
#          console.log "groupedBubblesByType"
#          console.log groupedBubblesByType

        object = {}
        object[unitId] = groupedBubblesByType

#          console.log "object"
#          console.log object
        visibleNodesWithGroupedBubbles.push(object)

      visibleNodesIds.forEach(getBubblesForUnitId)
#        console.log "in fetchBubbles..."
#        console.log "visibleNodesWithGroupedBubbles"
#        console.log visibleNodesWithGroupedBubbles

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
    interactiveContainer.appendChild(@createBubblesContainer(bubblesJSON))
#    for bubblesType, bubblesJSONArray of bubblesJSON
#      interactiveContainer.appendChild(@createBubblesContainer(bubblesType, bubblesJSONArray))

    # If dispatcher add plus button
    if $(".js-is-dispatcher").length > 0
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
  createBubblesContainer: (bubblesJSON) =>
#    console.log "in createBubblesContainer..."
#    console.log "bubblesJSON"
#    console.log bubblesJSON
    bubblesContainer = document.createElement('div')
    bubblesContainer.className = "js-node-bubbles-container"
#    bubblesContainer.setAttribute("data-bubble-type", bubblesType)
    for bubblesType, bubblesJSONArray of bubblesJSON
      bubblesContainer.appendChild(@createNormalBubbleContainer(bubblesType, bubblesJSONArray))

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
  createNormalBubbleContainer: (bubblesType, bubblesJSONArray) =>
#    console.log "in createNormalBubbleContainer..."
#    console.log "bubblesType"
#    console.log bubblesType
#    console.log "bubblesJSONArray"
#    console.log bubblesJSONArray
    normalBubbleContainer = document.createElement('span')
    normalBubbleContainer.className = "badge badge-grey-darker js-bubble-open unit-bubble-type-#{bubblesType}"
#    normalBubbleContainer.setAttribute("data-html", true)
    # Used for actions
    unitId = bubblesJSONArray[0].unit_id
    normalBubbleContainer.setAttribute("data-unit-id", unitId)
    normalBubbleContainer.id = "js-bubble-of-unit-#{unitId}-of-type-#{bubblesType}"
    normalBubbleContainer.setAttribute("data-bubble-type", bubblesType)
    normalBubbleContainer.innerHTML = bubblesJSONArray.length

    # If there isn't a popover for this bubble already create one
    if $(".js-node-popover-container[data-unit-id=#{unitId}][data-bubble-type=#{bubblesType}]").length == 0
#      console.log "creating popover for unit"
      $(".popover-backdrop")[0].appendChild(@createPopoverContainer(bubblesJSONArray))

    return normalBubbleContainer


  # Create popover container
  # @param unitJSON [JSON] all data from server for one node
  # @note is called at createNormalBubbleContainer
  createPopoverContainer: (bubblesJSONArray) ->
#    console.log "in createPopoverContainer..."
    unitId = bubblesJSONArray[0].unit_id
    bubblesType = bubblesJSONArray[0].type_integer
    popoverContainer = document.createElement('div')
    popoverContainer.className = "js-node-popover-container"
    popoverContainer.setAttribute("data-unit-id", unitId)
    popoverContainer.setAttribute("data-bubble-type", bubblesType)

    @renderPopoverForNormalBubble(bubblesJSONArray, popoverContainer)

    return popoverContainer


  # Renders popover for normal bubble
  # @param unitJSON [JSON] all data from server for one node
  # @param popoverContainer [DOM] container to render in
  # @note is called in createPopoverContainer
  renderPopoverForNormalBubble: (bubblesJSONArray, popoverContainer) ->
    unitId = bubblesJSONArray[0].unit_id
    bubblesType = bubblesJSONArray[0].type_integer
#    console.log "in renderPopoverForNormalBubble..."
    React.renderComponent(
      window.app.BubblesPopover(
        parent: "#js-bubble-of-unit-#{unitId}-of-type-#{bubblesType}"
        unitId: unitId
        bubbles: bubblesJSONArray
      ),
      popoverContainer
    )


#  # Create a bubble which indicates that object children' have got any nodes
#  # @return [DOM] bubble-indicator
#  # @note is called at createInteractiveContainer when node children
#  #   have got any bubbles
#  createChildrenHasBubblesIndicator: =>
#    console.log "in createChildrenHasBubblesIndicator..."
#    childrenHasBubblesIndicator = document.createElement('span')
#    childrenHasBubblesIndicator.className = "badge badge-orange js-children-has-bubbles"
#    childrenHasBubblesIndicator.title = "Есть объекты у детей"
#    childrenHasBubblesIndicator.innerHTML = "Д"
#
#    return childrenHasBubblesIndicator


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
  openModalToCreateBubble: (e) =>
    unitId = e.target.getAttribute("data-unit-id")
    action = "/units/#{unitId}/bubbles"

    $form = @openUnitBubbleForm(unitId, action, "Создать баббл", "post")

    $form[0].reset()
    $form.find("select").select2('val', "")


  # Opens modal with form on edit button click and resets it
  # @note is binded on page load
  openModalToEditBubble: (e) =>
    e.preventDefault()
    $this = $(e.target)

    bubbleText = $this.parents(".js-bubble-info").find(".js-bubble-text span:last-child").text()
    bubbleTypeInteger = $this.parents(".js-bubble-info").find(".js-bubble-type").data("type-integer")

    unitId = $this.parents(".js-node-popover-container").attr("data-unit-id")
    bubbleId = e.target.getAttribute("data-bubble-id")
    action = "/units/#{unitId}/bubbles/#{bubbleId}"

    $form = @openUnitBubbleForm(unitId, action, "Редактировать баббл", "patch")

    bubbleTypeSelect = $form.find("#unit_bubble_bubble_type")
    bubbleType = bubbleTypeSelect.find("option")[bubbleTypeInteger + 1].value

    $form.find("#unit_bubble_bubble_type").select2('val', bubbleType)
    $form.find("#unit_bubble_comment").val(bubbleText)
    $form.find("#unit_bubble_id").val(bubbleId)


  # Send id of selected node to 3d
  # @note is triggered on node click in jstree
  # @param e [jQuery.Event] click event
  # @param data [Object] this node data
  sendSelectedNodeId: (e, data)->
    console.log "sending unit id #{data.node.id} to unit.select channel"
    PubSub.publish('unit.select', data.node.id)


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