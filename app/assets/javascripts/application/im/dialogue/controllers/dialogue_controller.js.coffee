# Handles messages in a dialogue
# @note is created on any dialogue page
# @param $dialoguesContainer [jQuery DOM] container to render dialogues in
class @.app.DialogueController
  $dialogueContainer: null
  view: null

  constructor: (@$dialogueContainer) ->
    @view = new window.app.DialogueView(@$dialogueContainer)
