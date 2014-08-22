# Handles display of trees
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
class TreeHandler
  constructor: (@treeContainer) ->
    # On jstree node select send its id
    @treeContainer.on 'activate_node.jstree', @sendId

    # On tree render show all interactive elements
    # @todo-cbrwizard bug: after node reopening no data is shown because of jstree rerendering
    @treeContainer.on 'load_node.jstree', @showInteractiveElementsInTree

    if $(".js-is-dispatcher").length > 0
      # On add bubble click open form
      $(document).on "click", ".js-bubble-add", @openModalToCreateBubble

      # On edit bubble click open form
      $(document).on "click", ".js-edit-unit-bubble-btn", @openModalToEditBubble


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

    if $(".js-is-dispatcher").length > 0
      interactiveContainer.appendChild(@createAddBubbleBtn(unitJSON.id))

    return interactiveContainer


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
      # If there isn't a popover for this unit already
      if $(".js-node-popover-container[data-unit-id=#{unitJSON.id}]").length == 0
        $(".popover-backdrop")[0].appendChild(@createPopoverContainer(unitJSON))

    # If any children have any bubbles show an indicator
    if unitJSON.tree_has_bubbles
      bubblesContainer.appendChild(@createChildrenHasBubblesIndicator())

    return bubblesContainer


  # Create a bubble which will open an all bubbles popover
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

    return normalBubbleContainer


  # Create popover container
  # @param unitJSON [JSON] all data from server for one node
  # @note is called at createNormalBubbleContainer
  createPopoverContainer: (unitJSON) ->
    popoverContainer = document.createElement('div')
    popoverContainer.className = "js-node-popover-container"
    popoverContainer.setAttribute("data-unit-id", unitJSON.id)

    @renderPopoverForNormalBubble(unitJSON, popoverContainer)

    return popoverContainer


  # Renders popover for normal bubble
  # @param unitJSON [JSON] all data from server for one node
  # @param popoverContainer [DOM] container to render in
  renderPopoverForNormalBubble: (unitJSON, popoverContainer) ->
    console.log "rendering react..."
    React.renderComponent(
      window.app.BubblesPopover(
        parent: "#normal-bubble-#{unitJSON.id}"
        nodeId: unitJSON.id
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
    form.attr("method", "post")
    form[0].reset()
    form.find("select").select2('val', "")
    modalContainer.modal()


  # Opens modal with form on edit button click and resets it
  # @note is binded on page load
  # @todo combine it with openModalToCreateBubble
  openModalToEditBubble: (e) ->
    e.preventDefault()
    $this = $(this)

    bubbleText = $this.parents(".js-bubble-info").find(".js-bubble-text span:last-child").text()
    bubbleTypeInteger = $this.parents(".js-bubble-info").find(".js-bubble-type").data("type-integer")

    unitId = $this.parents(".js-node-popover-container").attr("data-unit-id")
    bubbleId = this.getAttribute("data-bubble-id")
    action = "/units/#{unitId}/bubbles/#{bubbleId}"
    modalContainer = $(".js-bubble-form")
    form = modalContainer.find("form")

    modalContainer.find(".modal-title").text("Редактировать баббл")
    form.find("input[type='submit']").val("Редактировать баббл")

    bubbleTypeSelect = form.find("#unit_bubble_bubble_type")
    bubbleType = bubbleTypeSelect.find("option")[bubbleTypeInteger + 1].value

    form.find("#unit_bubble_bubble_type").select2('val', bubbleType)
    form.find("#unit_bubble_comment").val(bubbleText)
    form.find("#unit_bubble_id").val(bubbleId)

    form.attr("action", action)
    form.attr("method", "patch")
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
    window.app.unitsTreeHandler.treeContainer.jstree("deselect_all", true)

    window.app.unitsTreeHandler.treeContainer.jstree("select_node", data)

  PubSub.subscribe('Selected objects', mySubscriber)


  # Container with one bubble info
  window.app.BubbleInfoContainer = React.createClass
    render: ->
      console.log "rendering 1 bubble info"
      React.DOM.div(className: "js-bubble-info", [
        React.DOM.h4(className: "js-bubble-text",
          "Сообщение: ", this.props.bubble.text
        )

        React.DOM.h5({className: "js-bubble-type", "data-type-integer": this.props.bubble.type_integer},
          "Тип: ", this.props.bubble.type
        )

        if $(".js-is-dispatcher").length > 0
          [React.DOM.a({
            href: "units/#{this.props.nodeId}/bubbles/#{this.props.bubble.id}"
            title: "Удалить"
            "data-method": "delete"
            "data-remote": true
            className: "js-delete-unit-bubble-btn btn btn-red-d"
          }, "Удалить")

          React.DOM.a({
            href: ""
            title: "Редактировать"
            "data-bubble-id": this.props.bubble.id
            className: "js-edit-unit-bubble-btn btn btn-sea-green"
          }, "Редактировать")]
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
          this.props.bubbles.map (bubble) =>
            window.app.BubbleInfoContainer
              nodeId: this.props.nodeId
              bubble: bubble
        )
      ]

    render : ->
      @.renderPopover(@.props.body)