// =require 'models/base'

var Bubble = Backbone.Model.extend({
});

var Bubbles = Backbone.Collection.extend({
  model: Bubble,
  url: 'api/bubbles.json',
});

window.models.units = new Units();
window.models.units.fetch();
