# Sends signals that messages are read
# @note is created in messages page and dashboard
# @param $dialogueContainer [jQuery DOM] container to render dialogues in
class @.app.MessageReader
  $dialogueContainer: null


  constructor: (@$dialogueContainer) ->
    @listenToActions()


  # Activates mousemove/keypress event listeners
  # @note is called on message creation
  activateInteractionListeners: =>
    $(document).off "keypress, mousemove"
    @listenToActions()


  # Starts listening to actions
  # @note is called on creation and on message creation
  listenToActions: =>
    $(document).one "keypress, mousemove", @_prepareToSendReadSignal


  # Initiates a countdown to signal that all messages have been read
  # @note is triggered on user mouse move/key press in listenToActions
  _prepareToSendReadSignal: =>
    url = @$dialogueContainer.data("clear-noty-path")
    setTimeout =>
      @_sendReadSignal(url)
    , 2000


  # Sends a signal indicating that all messages have been read
  # @note is called on prepareToSendReadSignal
  _sendReadSignal: (url) ->
    $.ajax
      url: url
      type: "POST"
    true
