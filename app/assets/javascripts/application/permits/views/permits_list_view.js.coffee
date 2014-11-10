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

    console.log idsToPrint
    if idsToPrint.length > 0
      $button
        .removeClass("disabled")
        .attr("href", "permits?type=#{$button.data("type")}&ids_to_print[]=#{idsToPrint}")
    else
      $button.addClass("disabled")


#    if value == "checked"
#      button.removeClass("disabled")
#    else
#      $.each($(@checkboxesSelector).find("input"), ->
#  #      console.log "checking an input..."
#        console.log $(@).attr("checked")
#        if $(@).attr("checked") == "checked"
#  #        console.log "set disabled"
#          toHide = false
#          return toHide
#      )
#      if toHide
#        #      console.log "add class"
#        $(view.buttonSelector).addClass("disabled")
#      else
#        #      console.log "remove class"
#        $(view.buttonSelector).removeClass("disabled")


  _toggleButton: ->


