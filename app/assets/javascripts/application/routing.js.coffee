$ ->
  app.Router = Backbone.Router.extend(
    routes:
      'units': 'units'
      'messages/broadcast': 'messages'
      'control/dashboard': 'control_dashboard'
      'dialogues': 'dialogues'
      'dashboard': 'dashboard'

    units: ->
      treeContainer = $(".js-units-tree-container")
      tree = new window.app.TreeController(treeContainer)


    messages: ->
      # делаем так, чтобы форма сообщения не скролилась при прокрутке сообщений
      $element = $(".js-not-scrollable-elem")
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

    # Renders dialogues on dialogues page
    dialogues: ->
      dialoguesContainer = $(".dialogues-container")
      React.renderComponent(
        window.app.Dialogue(
          dialoguesPath: dialoguesContainer.data("dialogues-url")
        ),
        dialoguesContainer[0]
      )

    control_dashboard: ->
      new window.app.UsersDashboardNotificationView("/broadcast/control", debug: false)
      $(document).on "change", ".js-change-global-control-form", ->
        $(@).closest("form").submit()
      $('select.js-select2-nosearch').select2(global.select2_nosearch)


    dashboard: ->
      $tvContainer = $("._tv")
      new window.app.TvController($tvContainer)

  )

  new app.Router()

  Backbone.history.start(pushState: true)
