# Handles events after nested form was dynamically added
# @note is used on role permission fields for example
class NestedForm

  # Reactivates plugins which are used in a nested form
  # @param form [jQuery selector] a form to turn plugins on in
  # @note is called on addition of fields event
  turnOnPlugins: (form) ->
    form.find('.js-select2').select2(global.params.select2)
    form.find('.js-select2-nosearch').select2(
      minimumResultsForSearch: -1
    )

  # Binds plugins activation on nested fields addition
  # @note event is fired by nested_form gem
  constructor: () ->
    $(document).on "nested:fieldAdded", (event) =>
      this.turnOnPlugins(event.field)

nestedFormHandler = new NestedForm