# Handles bubbles display and interaction
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
# @note model is located at models/bubbles.js
# @todo refactor it:
#   remove all debug stuff
#   refactor comments
class @.app.BubblesView
  # Contains info about bubbles model
  # @note is filled on refreshBubbles on model sync
  models: null
  controller: null
  decorator: null


  constructor: (@treeContainer) ->
    # Starts listening to websockets
    new window.app.bubbleCreateNotification("/broadcast/unit/bubble/create")
    new window.app.bubbleDestroyNotification("/broadcast/unit/bubble/destroy")

    @controller = new window.app.BubblesController(@)
    @decorator = new window.app.BubblesDecorator(@treeContainer)

    # On load model and open node events display needed bubbles
    @treeContainer.on 'open_node.jstree load_node.jstree', =>
      @_showBubbles(@.models)


  # Reloads bubbles with new data
  # @note is triggered on bubbles model load in units_page
  refreshBubbles: (models) =>
    @.models = models
    @treeContainer.jstree("refresh", true)


  # private

  # Shows bubbles for visible nodes
  # @note is triggered on open/load node
  # @param allNestedBubblesModelJSON [JSON]
  _showBubbles:(allNestedBubblesModelJSON) =>
    visibleNodes = $(".jstree-node")
    visibleNodesIds = _.pluck(visibleNodes, 'id')
    visibleNodesIds.forEach(@decorator.createInteractiveContainer)

    visibleNestedBubblesJSON = @controller.getBubblesForNodesFromJSON(visibleNodesIds, allNestedBubblesModelJSON)
    visibleNestedBubblesJSON.forEach(@_showBubblesForNode)


  # Creates all bubbles for a node
  # @param nestedBubbleJSON [JSON]
  # @note is called at _showBubbles for each node
  _showBubblesForNode: (nestedBubbleJSON) =>
    # Creates interactive container for each node
    $nodeToAddBubblesTo = @treeContainer.find($("#" + nestedBubbleJSON.unit_id))
    $interactiveContainer = $nodeToAddBubblesTo.find(".js-node-interactive-container").first()
    $interactiveContainer.append(@_bubblesContainerForUnit(nestedBubbleJSON.unit_id, nestedBubbleJSON.bubbles))


  # Creates containers for each bubble type of 1 unit
  # @param unitId [Uuid]
  # @param groupedNestedBubblesJSON [JSON]
  # @return [DOM] all bubbles container
  # @note is called at _showBubblesForNode
  _bubblesContainerForUnit: (unitId, groupedNestedBubblesJSON) =>
    bubblesContainer = document.createElement('div')
    bubblesContainer.className = "js-node-bubbles-container"

    # For each type create a bubble container
    for bubblesTypeInteger, nestedBubbleJSON of groupedNestedBubblesJSON
      bubblesContainer.appendChild(@decorator.oneBubbleContainer(unitId, bubblesTypeInteger, nestedBubbleJSON))

      # If there isn't a popover for current bubble already create one
      if $(".js-node-popover-container[data-unit-id=#{unitId}][data-bubble-type=#{bubblesTypeInteger}]").length == 0
        $(".popover-backdrop")[0].appendChild(@_bubblesPopoverContainer(unitId, bubblesTypeInteger, nestedBubbleJSON))

    return bubblesContainer



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

    allBubblesJSON = window.app.TreeInterface.getBubblesAttributes()

    bubblesOfThisUnitAndType = @controller.getBubblesOfUnitAndTypeFromJSON(unitId, bubblesTypeInteger, allBubblesJSON)

    bubblesOfThisUnitDescendantsAndType = @controller.getThisTypeDescendantsBubblesOfUnit(unitId, allBubblesJSON, bubblesTypeInteger)

    @_renderBubblesPopoverForThisType(unitId, nestedBubbleJSON.russian_name, bubblesTypeInteger, bubblesOfThisUnitAndType, bubblesOfThisUnitDescendantsAndType, popoverContainer)

    return popoverContainer


  # Renders popover for bubble one bubble type
  # @param unitId [Uuid]
  # @param bubblesTypeInteger [Integer]
  # @param bubblesTypeName [Integer] localized type name to display in popover
  # @param currentUnitAndTypeBubbles [Array of Objects] list of current type bubbles for current unit
  # @param currentTypeDescendantsBubbles [Array of Objects] list of current type bubbles for current unit' descendants
  # @param popoverContainer [DOM] container to render in
  # @param bubblesTypeName [String] name which should be displayed in type popover
  # @note is called in createPopoverContainer
  # note uses bubbles_popover.js.coffee
  _renderBubblesPopoverForThisType: (unitId, bubblesTypeName, bubblesTypeInteger, currentUnitAndTypeBubbles, currentTypeDescendantsBubbles, popoverContainer) ->

    React.renderComponent(
      window.app.BubblesPopover(
        parent: "#js-bubble-of-unit-#{unitId}-of-type-#{bubblesTypeInteger}"
        bubblesTypeName: bubblesTypeName
        unitId: unitId
        currentUnitAndTypeBubbles: currentUnitAndTypeBubbles
        currentTypeDescendantsBubbles: currentTypeDescendantsBubbles
      ),
      popoverContainer
    )


  # Opens modal with form and resets it
  # @note is triggered on add button click
  # @note is binded on bubbles model load
  openFormToCreateBubble: (e) =>
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
