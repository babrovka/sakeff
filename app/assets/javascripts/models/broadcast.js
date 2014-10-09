var Message = Backbone.Model.extend({
});

var Broadcast = Backbone.Collection.extend({
  model: Message,
  url: '/api/broadcast.json',
  parse: function (response) {
    return response.broadcast;
  }

});

window.models.broadcast = new Broadcast();
