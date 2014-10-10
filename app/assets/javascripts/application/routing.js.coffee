$ ->
  app.Router = Backbone.Router.extend(
    routes:
      'units': 'units'
      'messages/broadcast': 'dialogue'
      'messages/organization/:id': 'dialogue'
      'control/dashboard': 'control_dashboard'
      'dialogues': 'dialogues'
      'dashboard': 'dashboard'

    units: ->
      treeContainer = $(".js-units-tree-container")
      new window.app.TreeController(treeContainer)


    dialogue: ->
      $dialogueContainer = $("._dialogue-container")
      window.app.dialogueController = new window.app.DialogueController($dialogueContainer)
      window.app.messageReader = new window.app.MessageReader($dialogueContainer)


    # Renders dialogues on dialogues page
    dialogues: ->
      $dialoguesContainer = $(".dialogues-container")
      window.app.dialoguesController = new window.app.DialoguesController($dialoguesContainer)


    control_dashboard: ->
      new window.app.UsersDashboardNotificationView("/broadcast/control", debug: false)
      $(document).on "change", ".js-change-global-control-form", ->
        $(@).closest("form").submit()
      $('select.js-select2-nosearch').select2(global.select2_nosearch)


    dashboard: ->
      $tvContainer = $("._tv")
      new window.app.TvController($tvContainer)

      $dialogueContainer = $('._im')
      new window.app.widgets.ImController($dialogueContainer)
      window.app.messageReader = new window.app.MessageReader($dialogueContainer)

      $bubblesContainer = $("._bubbles-info")
      new window.app.BubblesInfoController($bubblesContainer)


      # Turn this on when any units/bubbles related widgets are present
      new window.app.UnitsModel()

      $(".js-grid").height $(window).height() - $(".js-grid").offset().top
      $('._grid').children().find('[class*="_grid__cell"]').css('padding', 5)


  )

  new app.Router()

  Backbone.history.start(pushState: true)
