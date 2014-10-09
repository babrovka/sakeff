# Dialogue model
# @note is used in DialoguesController
DialogueModel = Backbone.Model.extend({})
@.app.dialogues = Backbone.Collection.extend(
  model: DialogueModel
  url: "/api/dialogues.json"
)
