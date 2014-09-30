Dialogue = Backbone.Model.extend({})
@.app.dialogues = Backbone.Collection.extend(
  model: Dialogue
  url: "/api/dialogues.json"
)


#class @.app.Dialogue
#  collection: null
#
#  constructor: (url) ->
#    dialogueModel = Backbone.Model.extend({})
#
#    @collection = Backbone.Collection.extend(
#      model: dialogueModel
#      url: url
#    )
#
#  update: ->
#    @collection.fetch()




#class @.app.Dialogue
#  collection: null
#
#  constructor: (url) ->
#    console.log "creating Dialogue model..."
#    @collection = Backbone.Collection.extend(
#      model: Backbone.Model.extend()
#      url: url
#    )
#    console.log "@collection"
#    console.log @collection
#
#
#  update: =>
#    @collection.fetch()

