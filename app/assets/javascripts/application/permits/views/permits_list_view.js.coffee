# Displays print checkboxes in permits index
# @note is used in PermitsListController
class window.app.PermitsListView
  $container: null
  checkboxesSelector: ".js-permit-print-checkbox"
  buttonSelector: ".js-permit-print-button"


  # @param $container [jQuery DOM]
  constructor: (@$container) ->
    @_bindCheckboxes()


  # Updates print button params on checkbox change
  # @note is called on create
  _bindCheckboxes: =>
    $(document).on "change", @checkboxesSelector, @_updateIdsInButton


  # Updates ids in button
  # @note is called on checkbox change
  _updateIdsInButton: =>
    idsToPrint = @_getIdsToPrint()
    @_toggleButton(idsToPrint)


  # Collects ids which should be printed
  # @note is called on _updateIdsInButton
  # @return [Array of String(numbers)]
  _getIdsToPrint: ->
    idsToPrint = []
    checkboxes = $(@checkboxesSelector).find("input")
    $.each(checkboxes, ->
      $this = $(@)
      if $this.attr("checked") == "checked"
        idsToPrint.push($this.data("permit-id"))
    )
    idsToPrint


  # Toggles display of button and updates it with collected ids
  # @note is called on _updateIdsInButton
  # @param idsToPrint [Array of String(numbers)] permit ids which should be printed together
  _toggleButton: (idsToPrint) =>
    $button = $(@buttonSelector)
    if idsToPrint.length > 0
      $button
        .removeClass("disabled")
        .attr("href", "/permits/by_type/#{$button.data("type")}?ids_to_print=#{idsToPrint}")
    else
      $button.addClass("disabled")
