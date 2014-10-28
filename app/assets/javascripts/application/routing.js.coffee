$ ->
  app.Router = Backbone.Router.extend(
    routes:
      'units': 'units'
      'messages/broadcast': 'dialogue'
      'messages/organization/:id': 'dialogue'
      'control/dashboard': 'control_dashboard'
      'dialogues': 'dialogues'
      'dashboard': 'dashboard'
      'permits/new': 'permitsForm'

    units: ->
      $treeContainer = $(".js-units-tree-container")
      new window.app.TreeController($treeContainer) if $treeContainer.length


    dialogue: ->
      $dialogueContainer = $("._dialogue-container")
      if $dialogueContainer.length
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
      $(".js-grid").height $(window).height() - $(".js-grid").offset().top
      $('._grid').children().find('[class*="_grid__cell"]').css({'padding-left' : 15, 'padding-right' : 15 })

      $tvContainer = $("._tv")
      new window.app.widgets.TvController($tvContainer)

      $bubblesContainer = $("._bubbles-info")
      new window.app.widgets.BubblesInfoController($bubblesContainer)

      $favouritesContainer = $("._favourites")
      new window.app.widgets.FavouritesController($favouritesContainer)

      # Turn this on when any units/bubbles related widgets are present
      new window.app.widgets.UnitsModel()


      $dialogueContainer = $('._im')
      new window.app.widgets.ImController($dialogueContainer)
      window.app.messageReader = new window.app.MessageReader($dialogueContainer)

    permitsForm: ->
      $permitsFormContainer = $("._permits-form")
      new window.app.PermitsFormView($permitsFormContainer)
  )

  new app.Router()
  Backbone.history.start(pushState: true)
