// =require 'models/base'

var NestedBubble = Backbone.Model.extend({
});

var NestedBubbles = Backbone.Collection.extend({
  model: NestedBubble,
  url: '/api/unit_bubbles/nested_bubbles_amount'
});

window.models.nestedBubbles = new NestedBubbles();