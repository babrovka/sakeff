var OrganizationDialogue = Backbone.Collection.extend({
  model: window.models.Message,
  transport_url: function(){
    return "/messages/organization/"+this.receiver_id;
  },
  parse: function (response) {
    return response.organization_messages;
  }

});

window.models.organizationDialogue = new OrganizationDialogue();
