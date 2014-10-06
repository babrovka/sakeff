require 'acceptance_helper'

feature "Dialogues", dialogues: true do

  let(:user_without_access) { create(:user) }

  let(:user_with_access) do
    user_without_access.set_permission(:read_organization_messages, :granted)
    user_without_access.set_permission(:read_broadcast_messages, :granted)
    user_without_access
  end

  # let(:sender_organization){ create(:organization) }
  # let!(:sender_user) do
  #   user = user_with_access
  #   user.update(organization: sender_organization)
  # end
  #
  # let(:receiver_organization){ create(:organization) }
  # let!(:receiver_user) do
  #     user = user_with_access
  #     user.update(organization: receiver_organization)
  # end

  # let(:dialogue){ Im::Dialogue.new(user, :organization, receiver_organization.id ) }
  # let(:path) { messages_organization_path(receiver_organization.id) }

  let(:dialogues_link_text) { "Все диалоги" }

  describe "page access" do
    context "user doesn't have permissions to see dialogues page" do

      before do
        login_as user_without_access, scope: :user
        visit dialogues_path
      end

      it "doesn't display link in menu" do
        save_and_open_page
        expect(page).not_to have_content dialogues_link_text
      end
    end
  end
end
