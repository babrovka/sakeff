# Dialogue model
# @note is used in DialoguesController
window.models.Dialogue = Backbone.Model.extend({})

DialoguesCollection = Backbone.Collection.extend
    model : window.models.Dialogue
    url : "/api/dialogues.json"

@.models.dialogues = new DialoguesCollection()
