class window.ConsoleDebug
  constructor: (is_debug) ->
    @.is_debug = is_debug

  init: (obj) ->
    if @.is_debug
      str = if obj.length
        "#{obj.selector} --- SUCCESS INITED"
      else
        "#{obj.selector} --- FAIL INITED"
      console.log(str)