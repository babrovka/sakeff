// =require 'models/base'

var Bubble = Backbone.Model.extend({
});

var Bubbles = Backbone.Collection.extend({
  model: Bubble,
  url: '/api/unit_bubbles.json'
});

window.models.bubbles = new Bubbles();