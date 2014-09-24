# Handles display of trees
# @param treeContainer [jQuery selector] a container for a tree
# @note is created in TreeController
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
class @.app.TreeView
  constructor: (@treeContainer) ->
    # On hover simulate hover class for correct CSS
    $(document).on "mouseover", ".jstree-icon", ->
      parent = $(@).parent()
      parent.attr("aria-selected", true)
      parent.find("> .jstree-anchor").addClass("jstree-hovered")


  # Shows tree on units model load
  # @note this model is located at models/units.js
  showUnits:(__method, models) =>
    @treeContainer.jstree
      core:
        data: models
        themes:
          icons: false
          dots: false
      plugins: [ "sort" ]
      sort: (a, b) ->
        createdAtA = _.findWhere(models, {id: a}).created_at
        createdAtB = _.findWhere(models, {id: b}).created_at

        if createdAtA > createdAtB then 1 else -1


  # Displays 3d and other data
  # @note is called on treeController.fetchModels
  showThreeD: ->
    @_showNumberOfBubblesInHeader()

    # Load 3d only if container is present and it's not loaded already
    if $('._three-d').length > 0 && $('._three-d canvas').length == 0
      new ThreeDee('._three-d',
        marginHeight: 200,
        marginWidth: 30
      )


  # private

  # Shows number of bubbles of different types on page header
  # @note is called on showThreeD
  _showNumberOfBubblesInHeader: =>
    rootId = window.app.TreeInterface.getRootUnitId()
    allBubbles = window.app.TreeInterface.getNumberOfAllBubblesForUnitAndDescendants(rootId)

    accidentsAmount = allBubbles[0]
    workAmount = allBubbles[1]
    infoAmount = allBubbles[2]
    emergencyAmount = allBubbles[3]

    totalAmount = accidentsAmount + workAmount + infoAmount + emergencyAmount

    totalText = window.app.Pluralizer.pluralizeString(totalAmount, "сигнал","сигнала","сигналов")
    accidentText = window.app.Pluralizer.pluralizeString(accidentsAmount, "авария","аварии","аварий")
    emergencyText = window.app.Pluralizer.pluralizeString(emergencyAmount, "ЧП","ЧП","ЧП")
    workText = window.app.Pluralizer.pluralizeString(workAmount, "работа","работы","работ")
    infoText = window.app.Pluralizer.pluralizeString(infoAmount, "информация","информации","информаций")

    $(".js-total-bubbles-count").text(" #{totalAmount} #{totalText}:")
    $(".js-accidents-bubbles-count").text(" #{accidentsAmount} #{accidentText},")
    $(".js-work-bubbles-count").text(" #{workAmount} #{workText},")
    $(".js-info-bubbles-count").text(" #{infoAmount} #{infoText},")
    $(".js-emergency-bubbles-count").text(" #{emergencyAmount} #{emergencyText}")
