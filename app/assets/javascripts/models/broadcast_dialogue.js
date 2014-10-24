var BroadcastDialogue = Backbone.Collection.extend({
  model: window.models.Message,
  url: '/api/broadcast.json',
  transport_url: function () {
    return "/messages/broadcast/"
  },
  parse: function (response) {
    return response.broadcast;
  },
  sender_name: 'Циркулярные сообщения',
  receiver_id: 'broadcast',
  send_message_path: '/messages/broadcast'
});

window.models.broadcastDialogue = new BroadcastDialogue();
