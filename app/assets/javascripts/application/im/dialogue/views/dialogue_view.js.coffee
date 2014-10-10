# Handles interaction and display of messages
# @note is created in DialogueController
# @param $dialoguesContainer [jQuery DOM] container to render dialogues in
class @.app.DialogueView
  $dialogueContainer: null


  constructor: (@$dialogueContainer) ->
    $notScrollableElement = @$dialogueContainer.find(".js-not-scrollable-elem")
    @_makeFormUnscrollable($notScrollableElement)
    window.app.messageReader = new window.app.MessageReader(@$dialogueContainer)


  # Makes message create form unscrollable
  # @note is called on creation
  _makeFormUnscrollable: ($element) ->
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
