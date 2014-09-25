require 'acceptance_helper'

feature "User manage messages in organization dialogue", %q() do

  let(:sender_organization){ create(:organization) }
  let!(:user) { create(:user, organization: sender_organization) }

  let(:receiver_organization){ create(:organization) }
  let!(:receiver_user) do
    user = create(:user, organization: receiver_organization)
    user.set_permission(:read_organization_messages, :granted)
    user
  end

  let(:dialogue){ Im::Dialogue.new(:organization, sender_organization.id, receiver_organization.id ) }
  let(:path) { messages_organization_path(receiver_organization.id) }

  background do
    login_as user, scope: :user

    10.times do
      dialogue.send(create(:message, sender: user))
    end

    expect(dialogue.messages.count).to eq 10
  end

  describe 'dialogue page' do

    context 'with allowed permissions' do
      background do
        user.set_permission(:read_organization_messages, :granted)
      end

      scenario 'render all messages' do
        visit path
        dialogue.messages.each do |message|
          expect(page).to have_content message.text
        end
      end
    end

    context 'without permissions' do
      scenario 'will redirect out' do
        visit path
        expect(current_path).to_not eq path
        dialogue.messages.each do |message|
          expect(page).to_not have_content message.text
        end
      end
    end
  end

  describe 'write message to dialogue' do

    def write_message
      within '.spec-im-form' do
        fill_in 'im_message_text', with: new_message_text
      end
    end

    def send_message
      within '.spec-im-form' do
        click_on 'Отправить'
      end
    end

    context 'with allowed permissions' do
      let(:new_message_text) { 'new extra new message' }

      background do
        user.set_permission(:send_organization_messages, :granted)
        user.set_permission(:read_organization_messages, :granted)
        visit path
        expect(page).to_not have_content new_message_text
        expect(page).to have_css '.spec-im-form'

        write_message
        expect { send_message }.to change(Im::Message, :count)
      end


      scenario 'will render message on sender' do
        visit path
        expect(page).to have_content new_message_text
      end

      context 'on receiver area' do
        scenario 'will render received message ' do
          login_as receiver_user, scope: :user
          visit messages_organization_path(sender_organization)
          expect(page).to have_content new_message_text
        end
      end

    end

    context 'without permissions' do
      scenario 'will not allow' do
        visit path
        expect(page).to_not have_css('.spec-im-form')
      end
    end

  end


end

