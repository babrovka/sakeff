  require 'rails_helper'
  
  describe Im::Message do
    subject!(:message) { FactoryGirl.create(:message) }
    it_behaves_like 'ringbell notifier object'
  end