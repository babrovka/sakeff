// =require 'plugins/backbone/exoskeleton'
// =require 'plugins/backbone/backprop'

// TODO: move this before any of the models is defined
Backprop.extendModel(Backbone.Model);

var Unit = Backbone.Model.extend({
  id: Backprop.String(),
  parent: Backprop.String(),
  text: Backprop.String(),
});

var Units = Backbone.Collection.extend({
  model: Unit,
  url: 'api/units.json',
});


window.models || (window.models = {});
window.models.units = new Units();
window.models.units.fetch();
