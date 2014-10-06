require 'acceptance_helper'

feature "Dialogues", dialogues: true do
  let(:receiver_organization){ create(:organization) }
  let(:sender_organization){ create(:organization) }

  let(:user_without_access) { create(:user) }

  let(:user_with_access) do
    user = create(:user)
    user.update(organization: sender_organization)
    user.set_permission(:read_organization_messages, :granted)
    user.set_permission(:read_broadcast_messages, :granted)
    user
  end

  let(:dialogue){ Im::Dialogue.new(user_with_access, :organization, receiver_organization.id ) }
  let(:sender_dialogue){ Im::Dialogue.new(user_with_access, :organization, sender_organization.id ) }

  let(:dialogues_link_text) { "Все диалоги" }
  let(:dialogue_heading) { "Журнал диспетчерских сообщений" }

  describe ".index" do
    describe "page access" do
      context "user doesn't have permissions to see dialogues page" do
        before do
          login_as user_without_access, scope: :user
          visit users_root_path
        end

        it "doesn't display link in menu" do
          within("._left-menu") do
            expect(page).not_to have_content dialogues_link_text
          end
        end
      end

      context "user has got permission to see dialogues page" do
        before do
          login_as user_with_access, scope: :user
          visit users_root_path
        end

        it "displays link in menu" do
          within("._left-menu") do
            expect(page).to have_content dialogues_link_text
          end
        end
      end
    end

    describe "page interaction", js: true do
      before do
        login_as user_with_access, scope: :user

        dialogue.send(create(:message, sender: user_with_access))
        sender_dialogue.send(create(:message, sender: user_with_access))

        visit dialogues_path
      end

      it "doesn't show link to dialogue with user's organization" do
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
