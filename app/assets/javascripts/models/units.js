// =require 'models/base'

var Unit = Backbone.Model.extend({
  // only need to explicitly define properties to access without get/set
  // id: Backprop.String(),
  // parent: Backprop.String(),
  // text: Backprop.String(),
});

var Units = Backbone.Collection.extend({
  model: Unit,
  url: 'api/units.json',
});

window.models.units = new Units();
window.models.units.fetch();
