require 'rails_helper'

describe Im::Dialogue do 
  let(:message) { Im::Message.new(text: 'text')}

  context 'broadcast' do
    let(:user) {create(:user)}
    let(:dialogue) {Im::Dialogue.new(user, :broadcast)}

    it 'gets all broadcast messages' do
      3.times {create(:message)}
      3.times {create(:organization_message)}

      expect(dialogue.messages.count).to be == Im::Message.broadcast.count

      dialogue.messages.each {|m| expect(m.reach).to be == 'broadcast' }
    end

    it 'sends message' do
      message = Im::Message.new(text: 'text')

      expect(message).to receive(:notify_interesants)
      expect {dialogue.send(message)}.to change {Im::Message.count}.by(1)
      expect(message.reach).to be == 'broadcast'
    end
  end

  context 'between organizations' do
    let!(:sender_organization) { create(:organization) }
    let!(:sender_user) {create(:user, organization: sender_organization)}
    let!(:recipient_organization) { create(:organization) }
    let!(:third_organization) { create(:organization) }
    let!(:dialogue) { Im::Dialogue.new(sender_user, :organization, recipient_organization.id) }

    it 'sends message' do
      expect(message).to receive(:notify_interesants)
      dialogue.send(message)
      expect(message.reach).to eq 'organization'
      expect(message.sender_id).to eq sender_organization.id
      expect(message.receiver_id).to eq recipient_organization.id
    end

    it 'retrieves messages' do
        expect(dialogue.messages.count).to eq 0
        Im::Message.create!(sender_id: sender_organization.id, receiver_id: recipient_organization.id, text: 'hello', reach: :organization)
        Im::Message.create!(sender_id: recipient_organization.id, receiver_id: sender_organization.id, text: 'reply', reach: :organization)
     
        expect(dialogue.messages.count).to eq 2 # when messages method set up correct
      
        # when messages method set up incorrect 
        dialogue = Im::Dialogue.new(sender_user, :organization, third_organization.id)
        expect(dialogue.messages.count).to eq 0
    end
  end

end