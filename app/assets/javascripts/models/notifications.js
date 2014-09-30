var Notification = Backbone.Model.extend({
  // only need to explicitly define properties to access without get/set
  // name: 'broadcast' || organization-uuid
  // count
});

var Notifications = Backbone.Collection.extend({
  model: Notification,
  url: '/api/notifications.json',
  parse: function (response) {
    return response.notifications;
  }

});

window.models.notifications = new Notifications();
