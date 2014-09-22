require 'acceptance_helper'
require 'support/behaviours/units_tree_viewable'

feature "User interacts with units", js: true, units: true do

  let(:user) { create(:user) }
  let(:allowed_user) do
    user.permissions << Permission.where(title: 'manage_unit_status').first
    up = user.user_permissions.where(permission: Permission.where(title: :manage_unit_status)).first
    up.result = :granted
    up.save!
    user
  end
  let!(:unit) { create(:unit) }
  let!(:unit_bubble) { create(:unit_bubble) }
  let!(:child_unit) { create(:child_unit, parent: unit) }
  let!(:grandchild_unit) { create(:grandchild_unit, parent: child_unit) }

  describe 'on index page' do
    before do
      login_as(user, :scope => :user)
      visit units_path
    end

    describe "tree manipulation works correct" do
      it_behaves_like :units_tree_viewable
    end

    context 'has no units manipulation rights' do
      it "doesn't display bubbles add button" do

        expect(page).to_not have_css ".m-tree-add"
      end
    end

    context 'has got units manipulation rights' do
      before do
        login_as(allowed_user, :scope => :user)
        visit units_path
      end

      it "displays bubbles add button" do
        expect(page).to have_css ".m-tree-add"
      end

      it "has got one bubble at first" do
        expect(page.all(".js-bubble-open").count).to eq(1)
      end

      it "creates new bubble" do
        first(".js-bubble-open").click
        sleep(5)
        within ".m-active" do
          find('select').find(:xpath, 'option[2]').select_option
          fill_in 'unit_bubble[comment]', with: 'Bubble comment'
        end
      end
    end
  end
end
