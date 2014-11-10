# Displays print checkboxes in permits index
# @note is used in PermitsListController
class window.app.PermitsListView
  $container: null
  checkboxesSelector: ".js-permit-print-checkbox"
  buttonSelector: ".js-permit-print-button"


  # @param $container [jQuery DOM]
  constructor: (@$container) ->
    @_bindCheckboxes()


  _bindCheckboxes: =>
    $(document).on "change", @checkboxesSelector, @_toggleCheckbox


  _toggleCheckbox: =>
    view = @
    $button = $(view.buttonSelector)
    idsToPrint = []

    $.each($(@checkboxesSelector).find("input"), ->
      $this = $(@)
      if $this.attr("checked") == "checked"
        idsToPrint.push($this.data("permit-id"))
    )

    if idsToPrint.length > 0
      $button
        .removeClass("disabled")
        .attr("href", "/permits/by_type/#{$button.data("type")}?ids_to_print=#{idsToPrint}")
    else
      $button.addClass("disabled")


  _toggleButton: ->

