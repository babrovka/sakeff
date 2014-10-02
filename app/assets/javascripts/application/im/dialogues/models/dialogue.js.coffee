# Dialogue model
# @note is used in DialoguesController
dialogueModel = Backbone.Model.extend({})
@.app.dialogues = Backbone.Collection.extend(
  model: dialogueModel
  url: "/api/dialogues.json"
)
