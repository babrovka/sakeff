var Notification = Backbone.Model.extend({
});

var Notifications = Backbone.Collection.extend({
  model: Notification,
  url: '/api/notifications.json',
  parse: function (response) {
    return response.notifications;
  }

});

window.models.notifications = new Notifications();
