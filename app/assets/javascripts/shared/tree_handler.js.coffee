# Handles display of trees
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
class TreeHandler
  constructor: (@treeContainer) ->
#    @nodesWithBubbles = []
    # On jstree node select send its id
    @treeContainer.on 'changed.jstree', @sendId

    # On any nodes insertion into a tree check for bubbles
    @treeContainer.on 'load_node.jstree', @bubblesShow

    # On bubble click open it
    @treeContainer.on "click", ".js-bubble-open", @openBubble

  # Shows bubbles where needed
  bubblesShow: (_node, status) =>
    # Reject root parent node with id "#"
    dataNodes = _.reject status.instance._model.data, (node) ->
      node.id == "#"

    _.each dataNodes, (node) =>
      bubble = node.original.bubble
      nodeId = node.original.id
      childrenHasBubbles = node.original.tree_has_bubbles
#      childrenHasBubbles = node.original.childrenHasBubbles
      # Timeout because it takes time to render and it has no callback :[
      setTimeout =>
        $nodeWithBubble = @treeContainer.find($("#" + nodeId))
        # If node wasn't rendered yet
        unless $nodeWithBubble.hasClass("js-rendered-bubble")
          @addBubble($nodeWithBubble, bubble, childrenHasBubbles)
      , 10

  # Adds bubble container to a node
  # @param $node [jQuery DOM]
  # @param bubble [Object]
  # @param childrenHasBubbles [Boolean]
  addBubble: ($node, bubble, childrenHasBubbles) ->
    bubbleContainer = document.createElement('span')
    bubbleContainer.className = "js-bubble-container"

    # If node has a bubble render it
    # @todo create a bubble appender function and refactor with it
    if bubble
      bubbleOpenBtn = document.createElement('span')
      bubbleOpenBtn.className = "fa fa-user js-bubble-open"
      bubbleOpenBtn.setAttribute("html", true)

      alarmClass = switch
        when bubble.type == "alarm" then "label-red-d"
        when bubble.type == "success" then "label-green-d"
        else "label-gray-d"

      $(bubbleOpenBtn).tooltip
        title: '<span class="label ' + alarmClass + '">' + bubble.text + '</span>'
        html: true
        trigger: "click"
      bubbleContainer.appendChild(bubbleOpenBtn)

      # @todo check for dispatcher
      bubbleEditBtn = document.createElement('span')
      bubbleEditBtn.className = "fa fa-edit js-bubble-edit"
      bubbleEditBtn.title = "Редактировать"
      bubbleContainer.appendChild(bubbleEditBtn)

      bubbleRemoveBtn = document.createElement('span')
      bubbleRemoveBtn.className = "fa fa-times-circle js-bubble-remove"
      bubbleRemoveBtn.title = "Удалить"
      bubbleContainer.appendChild(bubbleRemoveBtn)
    else
      # @todo check for dispatcher
      bubbleRemoveBtn = document.createElement('span')
      bubbleRemoveBtn.className = "fa fa-plus-circle js-bubble-add"
      bubbleRemoveBtn.title = "Добавить"
      bubbleContainer.appendChild(bubbleRemoveBtn)

    if childrenHasBubbles
      bubbleChildrenBubblesIndicator = document.createElement('span')
      bubbleChildrenBubblesIndicator.className = "fa fa-child js-children-has-bubbles"
      bubbleChildrenBubblesIndicator.title = "Есть объекты у детей"
      bubbleContainer.appendChild(bubbleChildrenBubblesIndicator)

    $node
      .addClass("js-rendered-bubble")
      .find("> a")[0].appendChild(bubbleContainer)


  # Opens a bubble
  # @note is called on click on bubble icon in node tree
  openBubble: (e) ->
    console.log e.target
    # @todo open tooltip with bubble text in it and bubble type as class



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
  unitsTreeHandler = new TreeHandler($(".js-units-tree-container"))
  unitsTreeHandler.showTree()

  mySubscriber = (msg, data) ->
    console.log "received #{data} from #{msg} channel"

  PubSub.subscribe('Selected objects', mySubscriber)