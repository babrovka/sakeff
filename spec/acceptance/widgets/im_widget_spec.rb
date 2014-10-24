require 'acceptance_helper'

feature "User works with im widget", dialogues: true do

  let(:user){ create(:user) }
  let(:sender_organization) { user.organization }
  let(:receiver_organization) { create(:organization) }

  let!(:broadcast_messages) do
    5.times { create(:message, sender_user: user, reach: :broadcast) }
    Im::Dialogue.new(user, :broadcast).messages
  end

  let!(:organization_messages) do
    5.times { create(:message, :organization, sender_user: user, receiver_id: receiver_organization.id) }
    Im::Dialogue.new(user, :organization, receiver_organization.id).messages
  end

  let(:path) { users_root_path }

  background do
    login_as user, scope: :user
    visit path
    sleep 0.2
    expect(page).to have_css '.spec-im-widget'
  end

  describe 'dialogue messages list', js: true do
    context 'without permissions' do
      scenario 'not rendered' do
        expect(page).to have_content 'Нет доступных диалогов'
      end
    end
    context 'with permissions to read broadcast ' do
      scenario 'render only broadcast messages' do
        user.set_permission(:read_broadcast_messages, :granted)
        visit path

        expect(broadcast_messages.count).to be > 0
        expect(page).to_not have_content 'Нет доступных диалогов'
        expect(page).to_not have_css '.spec-im-widget-form-input'

        broadcast_messages.each do |message|
          expect(page).to have_content message.text
        end

        organization_messages.each do |message|
          expect(page).to_not have_content message.text
        end
      end
    end

  end

  describe 'dialogue sees form to send message', js: true do

    context 'without permissions' do
      scenario 'not rendered' do
        expect(page).to_not have_css '.spec-im-widget-form-input'
      end
    end

    context 'with permissions to send and read broadcast' do
      let(:new_message) { 'new send message text' }

      scenario 'can send message and see it in list' do
        user.set_permission(:read_broadcast_messages, :granted)
        user.set_permission(:send_broadcast_messages, :granted)
        visit path
        sleep 2
        within '.spec-im-widget' do
          expect(page).to have_css '.spec-im-widget-form-input'
          fill_in 'im_message[text]', with: new_message
          expect do
            page.execute_script("$('.spec-im-widget-form-input').closest('form').submit()")
            sleep 1
          end.to change Im::Message, :count
          sleep 1
          expect(page).to have_content new_message
        end
      end
    end

  end


end
