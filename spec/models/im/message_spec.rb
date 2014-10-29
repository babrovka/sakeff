  require 'rails_helper'
  
  describe Im::Message do

    before :all do
      Organization.destroy_all
      User.destroy_all
    end
    
    let!(:org1) {FactoryGirl.create(:organization)}
    let!(:org2) {FactoryGirl.create(:organization)}
    let!(:org3) {FactoryGirl.create(:organization)}

    let!(:alice1) {FactoryGirl.create(:user, organization: org1, username: 'Alice')}
    let!(:bob1) {FactoryGirl.create(:user, organization: org1, username: 'Bob')}
    let!(:pavel2) {FactoryGirl.create(:user, organization: org2, username: 'Pavel')}
    let!(:darya3) {FactoryGirl.create(:user, organization: org3, username: 'Darya')}


    # Broadcast message from "user" (from "organization")
    subject!(:message) { FactoryGirl.create(:message, sender_user: alice1) }

    # Message from "user" (from "organization") to "organization2"
    let!(:organization_message) {FactoryGirl.create(:organization_message, reach: :organization, sender_user_id: alice1.id, sender_id: org1.id, receiver_id: org2.id)}
    
    it_behaves_like 'ringbell notifier object'
 
    it "should provide correct receivers when reach == broadcast" do
      expect(message.receivers).to be == [bob1, pavel2, darya3]
    end

    it "should provide correct receivers when reach == organization" do
      expect(organization_message.receivers).to be == [bob1, pavel2]
    end

    it 'uses Mail Notification Engine' do
      m = Im::Message.new(text: 'text')

      mock_delay = double('mock_delay').as_null_object
      allow(NotificationMailer).to receive(:delay).and_return(mock_delay)
      expect (mock_delay).to receive(:notify)

      m.save!
	end
      
    it 'uses SMS Notification Engine' do
      darya3.update_attributes!(cell_phone_number: '7xxxxxxxxxx')

      m = Im::Message.new(text: 'text', reach: :organization, sender_user_id: alice1.id, sender_id: org1.id, receiver_id: org3.id)

      mock_delay = double('mock_delay').as_null_object
      allow(Im::SmsPresenter).to receive(:delay).and_return(mock_delay)
      expect (mock_delay).to receive(:send_message).once
      
      m.save!
      darya3.update_attributes!(cell_phone_number: '')
    end
  end