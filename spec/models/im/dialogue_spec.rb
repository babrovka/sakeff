require 'rails_helper'

describe Im::Dialogue do 
  context 'broadcast' do
    let!(:user) {create(:user)}
    let!(:receiver) {create(:user)}
    let!(:third_user) {create(:user)}
    let(:dialogue) {Im::Dialogue.new(user, :broadcast)}
    let(:receiver_dialogue) {Im::Dialogue.new(receiver, :broadcast)}
    let(:third_dialogue) {Im::Dialogue.new(third_user, :broadcast)}


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

    it 'counts unread messages' do
      expect {dialogue.send Im::Message.new(text: 'text')}.to change {receiver_dialogue.unread_messages.count}.by(1)
    end

    it 'clears unread messages' do
      m = FactoryGirl.build(:message)
      dialogue.send(m)

      expect(receiver_dialogue.unread_messages.count).to be == 1
      expect(third_dialogue.unread_messages.count).to be == 1

      receiver_dialogue.clear_notifications

      expect(receiver_dialogue.unread_messages.count).to be == 0
      expect(third_dialogue.unread_messages.count).to be == 1
    end
  end

  context 'between organizations' do
    let!(:sender_organization) { create(:organization) }
    let!(:recipient_organization) { create(:organization) }
    let!(:third_organization) { create(:organization) }
    
    let!(:sender_user) {create(:user, organization: sender_organization)}
    let!(:recipient_user) {create(:user, organization: recipient_organization)}
    let!(:third_user) {create(:user, organization: third_organization)}

    let!(:dialogue) { Im::Dialogue.new(sender_user, :organization, recipient_organization.id) }
    let!(:recipient_dialogue) { Im::Dialogue.new(recipient_user, :organization, sender_organization.id) }
    let!(:third_dialogue) { Im::Dialogue.new(sender_user, :organization, third_organization.id) }
    let!(:another_dialogue) { Im::Dialogue.new(third_user, :organization, sender_organization.id) }

    it 'sends message' do
      message = Im::Message.new(text: 'text')
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

    it 'counts unread messages' do
      expect {dialogue.send Im::Message.new(text: 'text')}.to change {recipient_dialogue.unread_messages.count}.by(1)
      expect {dialogue.send Im::Message.new(text: 'text')}.not_to change {dialogue.unread_messages.count}
      expect {dialogue.send Im::Message.new(text: 'text')}.not_to change {third_dialogue.unread_messages.count}
      expect {dialogue.send Im::Message.new(text: 'text')}.not_to change {another_dialogue.unread_messages.count}
    end

    it 'clears unread messages' do
      m = FactoryGirl.build(:organization_message)

      expect {dialogue.send(m)}.to change {recipient_dialogue.unread_messages.count}.from(0).to(1)
      expect {recipient_dialogue.clear_notifications}.to change {recipient_dialogue.unread_messages.count}.from(1).to(0)
    end
  end
end