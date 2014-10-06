require 'acceptance_helper'

feature "Dialogues", dialogues: true do

  let(:user_without_access) { create(:user) }

  let(:user_with_access) do
    user_without_access.set_permission(:read_organization_messages, :granted)
    user_without_access.set_permission(:read_broadcast_messages, :granted)
    user_without_access
  end

  let(:sender_organization){ create(:organization) }
  let(:sender_user) do
    user = user_with_access
    user.update(organization: sender_organization)
    user
  end

  let(:receiver_organization){ create(:organization) }
  let(:receiver_user) do
      user = user_with_access
      user.update(organization: receiver_organization)
      user
  end

  let(:dialogue){ Im::Dialogue.new(user_with_access, :organization, receiver_organization.id ) }
  let(:sender_dialogue){ Im::Dialogue.new(user_with_access, :organization, sender_organization.id ) }

  let(:path) { messages_organization_path(receiver_organization.id) }

  let(:dialogues_link_text) { "Все диалоги" }
  let(:dialogue_heading) { "Журнал диспетчерских сообщений" }

  describe "dialogues page" do
    describe "page access" do
      context "user doesn't have permissions to see dialogues page" do
        before do
          login_as user_without_access, scope: :user
          visit dialogues_path
        end

        it "doesn't display link in menu" do
          expect(page).not_to have_content dialogues_link_text
        end
      end

      context "user has got permission to see dialogues page" do
        before do
          login_as user_with_access, scope: :user
          visit dialogues_path
        end

        it "displays link in menu" do
          expect(page).to have_content dialogues_link_text
        end
      end
    end

    describe "page interaction", js: true do
      before do
        login_as sender_user, scope: :user

        5.times do
          dialogue.send(create(:message, sender: sender_user))
          sender_dialogue.send(create(:message, sender: sender_user))
        end

        expect(dialogue.messages.count).to eq 5

        visit dialogues_path
      end

      it "doesn't show link to dialogue with user's organization" do
        save_and_open_page
        expect(page).not_to have_content sender_organization.short_title
      end

      it "shows link to dialogue with other organization" do
        expect(page).to have_content receiver_organization.short_title
      end

      it "goes to a dialogue page by clicking on it's link" do
        click_link receiver_organization.short_title
        expect(page).to have_content dialogue_heading
      end
    end
  end
end
