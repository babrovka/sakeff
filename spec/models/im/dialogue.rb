require 'rails_helper'

describe Im::Dialogue do 
  describe '#messages' do
    context 'broadcast' do
      let(:dialogue) {Im::Dialogue.new(:broadcast)}

      it 'gets all broadcast messages' do
        3.times {create(:message)}
        3.times {create(:organization_message)}

        expect(dialogue.messages.count).to be == Im::Message.broadcast.count

        dialogue.messages.each {|m| expect(m.reach).to be == 'broadcast' }
      end
    end

    context 'between organization' do

      let!(:sender_organization) { create(:organization) }
      let!(:recipient_organization) { create(:organization) }
      let!(:third_organization) { create(:organization) }
      let!(:dialogue) { Im::Dialogue.new(:organization, sender_organization.id, recipient_organization.id) }
      
      before do
        expect(dialogue.messages.count).to eq 0
        Im::Message.create!(sender_id: sender_organization.id, receiver_id: recipient_organization.id, text: 'hello', reach: :organization)
        Im::Message.create!(sender_id: recipient_organization.id, receiver_id: sender_organization.id, text: 'reply', reach: :organization)
      end
      
      it 'has sender and receiver' do 
        expect(dialogue.sender_id).to eq sender_organization.id
        expect(dialogue.receiver_id).to eq recipient_organization.id
      end
      
      it "when messages method set up correct" do
        expect(dialogue.messages.count).to eq 2
      end
      
      it "when messages method set up incorrect" do
        dialogue = Im::Dialogue.new(:organization, sender_organization.id, third_organization.id)
        expect(dialogue.messages.count).to eq 0
      end
    
    end
  end

  describe '#send' do
    context 'broadcast' do
      let!(:sender_user) { create(:user) }
      let!(:dialogue) {Im::Dialogue.new(:broadcast)}

      it 'sends message' do
        message = Im::Message.new(sender_user_id: sender_user.id, text: 'text')

        expect(message).to receive(:notify_interesants)
        expect {dialogue.send(message)}.to change {Im::Message.count}.by(1)
        expect(message.reach).to be == 'broadcast'
      end
    end

    context 'between organization' do
      let!(:dialogue) { Im::Dialogue.new(:organization) }
      let!(:sender_organization) { create(:organization) }
      let!(:sender_user) { create(:user, organization: sender_organization) }
      let!(:recipient_organization) { create(:organization) }
      
      it "sends message" do
        message = Im::Message.new(sender_user_id: sender_user.id, receiver_id: recipient_organization.id, text: 'text')
        expect(message).to receive(:notify_interesants)
        dialogue.send(message)
        expect(message.reach).to eq 'organization'
        expect(message.sender_id).to eq sender_organization.id
        expect(message.receiver_id).to eq recipient_organization.id
      end
    end
  end
end