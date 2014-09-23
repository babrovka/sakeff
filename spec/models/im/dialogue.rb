require 'rails_helper'

describe Im::Dialogue do
  
  describe '#messages' do
    context 'between organization' do
      
      let!(:dialogue) { Im::Dialogue.new(:organization) }
      let!(:sender_organization) { create(:organization) }
      let!(:recipient_organization) { create(:organization) }
      let!(:third_organization) { create(:organization) }
      
      before do
        expect(dialogue.messages(sender_organization.id, recipient_organization.id).count).to eq 0
        Im::Message.create!(sender_id: sender_organization.id, receiver_id: recipient_organization.id, text: 'hello', reach: 1)
        Im::Message.create!(sender_id: recipient_organization.id, receiver_id: sender_organization.id, text: 'reply', reach: 1)
      end
  
      
      it "when messages method set up correct" do
        expect(dialogue.messages(sender_organization.id, recipient_organization.id).count).to eq 2
      end
      
      it "when messages method set up incorrect" do
        expect(dialogue.messages(sender_organization.id, third_organization.id).count).to eq 0
      end
    
    end
  end

  describe '#send' do
    context 'between organization' do
      
      let!(:dialogue) { Im::Dialogue.new(:organization) }
      let!(:sender_organization) { create(:organization) }
      let!(:sender_user) { create(:user, organization: sender_organization) }
      let!(:recipient_organization) { create(:organization) }
  
      
      it "sends message" do
        message = Im::Message.new(sender_user_id: sender_user.id, receiver_id: recipient_organization.id, text: 'text')
        dialogue.send(message)
        expect(message.reach).to eq 'organization'
        expect(message.sender_id).to eq sender_organization.id
        expect(message.receiver_id).to eq recipient_organization.id
      end

    
    end
  end


end