#= require application/im/dialogues/controllers/dialogues_controller
#= require application/im/dialogues/controllers/dialogue_notification
#= require application/im/dialogues/models/dialogue
#= require application/im/dialogues/views/dialogues_view

reactUtils = React.addons.TestUtils

describe "DialoguesController", ->
  it "can be created in view", ->
    setFixtures("<div class='dialogues-container'></div>")
    dialoguesContainer = $(".dialogues-container")
    window.app.dialoguesController = new window.app.DialoguesController(dialoguesContainer)

    expect(reactUtils.isCompositeComponent(window.app.dialoguesController.view)).toBeTruthy()
