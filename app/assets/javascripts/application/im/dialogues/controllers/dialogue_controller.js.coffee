#
# @note is created on
# @param @$dialoguesContainer [jQuery DOM] container to render dialogues in
class @.app.DialogueController
  $dialogueContainer: null
  view: null

  # @note subscribes to view mount so that it loads models only after view readiness
  constructor: (@$dialogueContainer) ->
    @view = new window.app.DialogueView(@$dialogueContainer)


  # Activates mousemove/keypress event listeners
  # @note is called on message creation
  activateInteractionListeners: =>
    $(document).off "keypress, mousemove"
    @view.listenToActions()
