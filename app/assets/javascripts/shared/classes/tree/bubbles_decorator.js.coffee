class @.app.BubblesDecorator
  treeContainer: null

  constructor: (treeContainer) ->
    @treeContainer = treeContainer

  # Creates interactive container for a unit which will contain all bubbles and + btn
  # @note is called at _showBubbles for each node
  # @param unitId [Uuid]
  createInteractiveContainer: (unitId) =>
    $nodeToAddBubblesTo = @treeContainer.find("#" + unitId)

    $nodeToAddBubblesTo.find(".js-node-interactive-container").remove()
    $nodeToAddBubblesTo.find("> a")
      .append(@_interactiveContainer(unitId))


  # Returns a new bubble container for certain bubble type
  # @note is called at _bubblesContainerForUnit for each bubble type
  # @param unitId [Uuid]
  # @param bubblesTypeInteger [Integer]
  # @param nestedBubbleJSON [JSON]
  # @return [DOM] one type bubble container
  oneBubbleContainer: (unitId, bubblesTypeInteger, nestedBubbleJSON) =>
    normalBubbleContainer = document.createElement('span')
    normalBubbleContainer.className = "badge js-bubble-open unit-bubble-type-#{bubblesTypeInteger}"
    normalBubbleContainer.id = "js-bubble-of-unit-#{unitId}-of-type-#{bubblesTypeInteger}"

    cyrillicName = switch parseInt(bubblesTypeInteger)
      when 0 then window.app.Pluralizer.pluralizeString(nestedBubbleJSON.count, "авария","аварии","аварий")
      when 1 then window.app.Pluralizer.pluralizeString(nestedBubbleJSON.count, "работа","работы","работ")
      when 2 then window.app.Pluralizer.pluralizeString(nestedBubbleJSON.count, "информация","информации","информаций")
      else window.app.Pluralizer.pluralizeString(nestedBubbleJSON.count, "ЧП","ЧП","ЧП")

    normalBubbleContainer.title = "#{nestedBubbleJSON.count} #{cyrillicName}"
    normalBubbleContainer.innerHTML = nestedBubbleJSON.count

    return normalBubbleContainer


  # private

  # Returns a container for all bubbles and + btn
  # @param unitId [Uuid]
  # @return [DOM] interactive container
  # @note is called in _createInteractiveContainer
  _interactiveContainer: (unitId) =>
    interactiveContainer = document.createElement('div')
    interactiveContainer.className = "js-node-interactive-container"

    # If current user can add bubbles
    if window.app.CurrentUser.hasPermission("manage_unit_status")
      interactiveContainer.appendChild(@_addBubbleBtn(unitId))

    return interactiveContainer

  # Creates a button which opens a form to add bubbles to a unit
  # @param unitId [Integer] id of current node
  # @return [DOM] button
  # @note is called at _interactiveContainer
  _addBubbleBtn: (unitId) =>
    uniq_class_name = "js-bubble-add-#{unitId}"
    bubbleAddBtn = document.createElement('span')
    bubbleAddBtn.className = "badge #{uniq_class_name} m-tree-add"
    bubbleAddBtn.title = "Добавить"
    bubbleAddBtn.setAttribute("data-unit-id", unitId)
    bubbleAddBtn.innerHTML = "+1"

    @_createAddBubbleForm(unitId, uniq_class_name)

    return bubbleAddBtn


  # Creates add bubble form for each add button
  # @note is called in @_createAddBubbleForm
  _createAddBubbleForm: (unitId, uniq_class_name) ->
    container_class_name = "add-bubble-form-#{unitId}"
    unitName = window.models.units.findWhere(id : unitId).attributes.text

    # по неизвестной причине, данный метод срабатывает три раза для корневого элемента
    # поэтому на корневого элемента создавалось 3 бабла
    # чтобы не делать кучу баблов, сделали такую проверку на уникальность контейнера, в который кладется поповер.
    unless $(".#{container_class_name}").length
      $container = $("<div class='#{container_class_name}'></div>").appendTo('.popover-backdrop')
      React.renderComponent(
        window.NewTreeBubblePopover(
          parent : ".#{uniq_class_name}"
          unitId: unitId
          unitName: unitName
          placement: 'right'
          width: 500
        ),
        $container[0]
      )

