# Handles display of trees
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
class TreeHandler
  constructor: (@treeContainer) ->
    # On jstree node select send its id
    @treeContainer.on 'changed.jstree', @sendId

    # On tree render show all interactive elements
    # @todo-cbrwizard bug: after node reopening no data is shown because of jstree rerendering
    @treeContainer.on 'load_node.jstree', @showInteractiveElementsInTree

    # On add bubble click open form
    $(document).on "click", ".js-bubble-add", @openModalToCreateBubble
#    $(document).on "click", ".js-bubble-add", @openModalToCreateBubble


  # Shows interactive elements in all rendered nodes
  # @param __ [NOT USED]
  # @param status [Object] jstree loaded object
  # @note is called on jstree load
  showInteractiveElementsInTree: (__, status) =>
    # Reject root parent node with id "#"
    normalNodes = _.reject status.instance._model.data, (node) ->
      node.id == "#"
    _.each normalNodes, @showInteractiveElementsInNode


  # Creates interactive elements for node
  # @note is called at showInteractiveElementsInTree for each node
  showInteractiveElementsInNode: (node) =>
    unitJSON = node.original

    # Timeout because it takes time to render and it has no callback :[
    setTimeout =>
      $nodeWithBubble = @treeContainer.find($("#" + unitJSON.id))
      # If node hasn't rendered yet
      unless $nodeWithBubble.hasClass("js-rendered-bubble")
        $nodeWithBubble
          .addClass("js-rendered-bubble")
          .find("> a")[0]
            .appendChild(@createInteractiveContainer(unitJSON))
    , 10


  # Creates an interactive container container for a node
  # @param unitJSON [JSON] all data from server for this node
  # @return [DOM] interactive container
  # @note is called in showInteractiveElementsInNode when node is rendered
  createInteractiveContainer: (unitJSON) =>
    interactiveContainer = document.createElement('div')
    interactiveContainer.className = "js-node-interactive-container"
    interactiveContainer.appendChild(@createBubblesContainer(unitJSON))

    # @todo check for dispatcher
    interactiveContainer.appendChild(@createAddBubbleBtn(unitJSON.id))



    return interactiveContainer


    # If node has a bubble render it
#    _.each bubbles, (bubble) =>
#      bubbleOpenBtn = document.createElement('span')
#      bubbleOpenBtn.className = "fa fa-user js-bubble-open"
#      bubbleOpenBtn.setAttribute("data-html", true)
#      bubbleOpenBtn.setAttribute("data-bubble-id", bubble.id)
#
#
##      alarmClass = switch
##        when bubble.type == "alarm" then "label-red-d"
##        when bubble.type == "success" then "label-green-d"
##        else "label-gray-d"
##
##      $(bubbleOpenBtn).tooltip
##        title: '<span class="label ' + alarmClass + '">' + bubble.text + '</span>'
##        html: true
##        trigger: "click"
#      bubbleContainer.appendChild(bubbleOpenBtn)
#
#      # @todo check for dispatcher
#      # @todo add modal trigger and make it change path of modal
#      bubbleEditBtn = document.createElement('span')
#      bubbleEditBtn.className = "fa fa-edit js-bubble-edit"
#      bubbleEditBtn.title = "Редактировать"
#      bubbleEditBtn.setAttribute("data-bubble-id", bubble.id)
#      bubbleContainer.appendChild(bubbleEditBtn)
#
#      bubbleRemoveBtn = document.createElement('a')
#      bubbleRemoveBtn.setAttribute("data-bubble-id", bubble.id)
#      bubbleRemoveBtn.href = "units/#{nodeId}/bubbles/#{bubble.id}"
#      bubbleRemoveBtn.title = "Удалить"
##      bubbleRemoveBtn.setAttribute("data-confirm", "Точно удалить?")
#      bubbleRemoveBtn.setAttribute("data-method", "delete")
#      bubbleRemoveBtn.setAttribute("data-remote", true)
#
#      bubbleRemoveBtnIcon = document.createElement('span')
#      bubbleRemoveBtnIcon.className = "fa fa-times-circle js-bubble-remove"
#      bubbleRemoveBtn.appendChild(bubbleRemoveBtnIcon)
#      bubbleContainer.appendChild(bubbleRemoveBtn)


  # Create all bubbles container
  # @param unitJSON [JSON] all data from server for one node
  # @return [DOM] all bubbles container
  # @note is called at createInteractiveContainer
  createBubblesContainer: (unitJSON) =>
    bubblesContainer = document.createElement('div')
    bubblesContainer.className = "js-node-bubbles-container"

    # If there is at least one bubble for this unit
    if unitJSON.bubbles && unitJSON.bubbles.length > 0
      bubblesContainer.appendChild(@createNormalBubbleContainer(unitJSON))

    # If any children have any bubbles show an indicator
    if unitJSON.tree_has_bubbles

#      console.log "we're at createBubblesContainer"
#      console.log "@createChildrenHasBubblesIndicator="
#      console.log @createChildrenHasBubblesIndicator()

      bubblesContainer.appendChild(@createChildrenHasBubblesIndicator())

    return bubblesContainer


  # Create a bubble which will open an all bubbles popup
  # @param unitJSON [JSON] all data from server for one node
  # @return [DOM] normal bubble container
  # @note is called at createInteractiveContainer when node has any
  #   bubbles
  createNormalBubbleContainer: (unitJSON) =>
    normalBubbleContainer = document.createElement('span')
    normalBubbleContainer.className = "badge badge-grey-darker js-bubble-open"
    normalBubbleContainer.setAttribute("data-html", true)
    normalBubbleContainer.setAttribute("data-unit-id", unitJSON.id)
    normalBubbleContainer.id = "normal-bubble-#{unitJSON.id}"
    normalBubbleContainer.setAttribute("data-bubble-type", "normal") # for future use
    normalBubbleContainer.innerHTML = "5"

    @renderPopupForNormalBubble(unitJSON)

    return normalBubbleContainer


  # Create popover container
  # @param unitJSON [JSON] all data from server for one node
  # @note is called at createNormalBubbleContainer
  renderPopupForNormalBubble: (unitJSON) ->
    console.log "rendering react..."
    popoverContainer = document.createElement('div')
    popoverContainer.className = "js-node-popover-container"
    popoverContainer.setAttribute("data-unit-id", unitJSON.id)
    $(".popover-backdrop")[0].appendChild(popoverContainer)

    React.renderComponent(
      window.app.BubblesPopover(
        parent: "#normal-bubble-#{unitJSON.id}"
        bubbles: unitJSON.bubbles

      ),
      popoverContainer
    )


  # Create a bubble which indicates that object children' have got any nodes
  # @return [DOM] bubble-indicator
  # @note is called at createInteractiveContainer when node children
  #   have got any bubbles
  createChildrenHasBubblesIndicator: =>
    childrenHasBubblesIndicator = document.createElement('span')
    childrenHasBubblesIndicator.className = "badge badge-orange js-children-has-bubbles"
    childrenHasBubblesIndicator.title = "Есть объекты у детей"
    childrenHasBubblesIndicator.innerHTML = "Д"

    return childrenHasBubblesIndicator


  # Create a button which adds bubbles to a unit
  # @param nodeId [Integer] id of this node
  # @return [DOM] button
  # @note is called at createInteractiveContainer when user is dispatcher
  # @todo make it change path of modal on click
  # @todo add click action
  createAddBubbleBtn: (nodeId) =>
    bubbleAddBtn = document.createElement('span')
    bubbleAddBtn.className = "badge badge-green js-bubble-add"
    bubbleAddBtn.title = "Добавить"
    bubbleAddBtn.setAttribute("data-unit-id", nodeId)
    bubbleAddBtn.innerHTML = "+"

    return bubbleAddBtn


  # Opens modal with form on add button click and resets it
  # @note is binded on page load
  openModalToCreateBubble: ->
    unitId = this.getAttribute("data-unit-id")
    action = "/units/#{unitId}/bubbles"
    modalContainer = $(".js-bubble-form")
    form = modalContainer.find("form")

    modalContainer.find(".modal-title").text("Создать баббл")
    form.find("input[type='submit']").val("Создать баббл")

    form.attr("action", action)
    form[0].reset()
    form.find("select").select2('val', "")
    modalContainer.modal()


  # Displays a tree in a tree container
  showTree: ->
    @treeContainer.jstree
      core:
        data:
          url: @treeContainer.attr("data-url")
          data: (node) ->
            id: node.id
        themes:
          dots: false
          icons: false


  # Send id of selected node to 3d
  # @note is triggered on node click
  # @param e [jQuery.Event] click event
  # @param data [Object] this node data
  sendId: (e, data)->
    PubSub.publish('Selected objects', data.node.id)


$ ->
  treeContainer = $(".js-units-tree-container")
  window.app.unitsTreeHandler = new TreeHandler(treeContainer)
  window.app.unitsTreeHandler.showTree()

  mySubscriber = (msg, data) ->
    console.log "received #{data} from #{msg} channel"

  PubSub.subscribe('Selected objects', mySubscriber)


  # Container with one bubble info
  window.app.BubbleInfoContainer = React.createClass
    render: ->
      console.log "rendering 1 bubble info"
      React.DOM.div(className: "js-bubble-info", 'data-attr': 'vit',[
        React.DOM.h4(null,
          "Text: ", this.props.bubble.text
        )
        React.DOM.h5(null,
          "Type: ", this.props.bubble.type
        )
      ])


  # Bubbles popover container
  # @note is created when a node has any bubbles
  window.app.BubblesPopover = React.createClass
    mixins : [PopoverMixin]

    getDefaultProps : ->
      text: "LOLA"
      width: 300
      body: [
        React.DOM.h3(null,
          "Все инфо бабблы"
        ),
        React.DOM.div(null,
          this.props.bubbles.map (bubble) ->
            window.app.BubbleInfoContainer
              bubble: bubble
        )
      ]

    render : ->
      @.renderPopover(@.props.body)