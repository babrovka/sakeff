# Handles interaction and display of messages
# @note is created in DialogueController
# @param $dialoguesContainer [jQuery DOM] container to render dialogues in
class @.app.DialogueView
  $dialogueContainer: null


  constructor: (@$dialogueContainer) ->
    $notScrollableElement = $dialogueContainer.find(".js-not-scrollable-elem")
    @makeFormUnscrollable($notScrollableElement)
    @listenToActions()


  # Starts listening to actions
  # @note is called on creation and on message creation
  listenToActions: =>
    $(document).one "keypress, mousemove", @prepareToSendReadSignal


  # Initiates a countdown to signal that all messages have been read
  # @note is triggered on user mouse move/key press in listenToActions
  prepareToSendReadSignal: =>
    url = @$dialogueContainer.data("clear-noty-path")
    setTimeout =>
      @sendReadSignal(url)
    , 2000


  # Sends a signal indicating that all messages have been read
  # @note is called on prepareToSendReadSignal
  sendReadSignal: (url) ->
    $.ajax
      url: url
      type: "POST"
    true


  # Makes message create form unscrollable
  # @note is called on creation
  makeFormUnscrollable: ($element) ->
    if $element.length
      elem_width = $element.outerWidth()
      topOnLoad = $element.offset().top
      $(window).scroll ->
        if topOnLoad <= $(window).scrollTop()
          $element.css
            position : "fixed"
            top : 0
            'padding-top' : '20px'
            width : elem_width
            'z-index' : 1
            'box-shadow' : '0 10px 10px -10px black'
        else
          $element.css
            position : "relative"
            top : ""
            'box-shadow' : 'none'
            'padding-top' : 0
