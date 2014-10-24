#= require application/im/dialogues/controllers/dialogues_controller
#= require ../../../../../app/assets/javascripts/application/im/dialogues/controllers/dialogues_notification.js.coffee
#= require ../../../../../app/assets/javascripts/models/dialogue.js.coffee
#= require application/im/dialogues/views/dialogues_view

reactUtils = React.addons.TestUtils

describe "DialoguesController", ->
  it "can be created in view", ->
    setFixtures("<div class='dialogues-container'></div>")
    dialoguesContainer = $(".dialogues-container")
    window.app.dialoguesController = new window.app.DialoguesController(dialoguesContainer)

    expect(reactUtils.isCompositeComponent(window.app.dialoguesController.view)).toBeTruthy()
