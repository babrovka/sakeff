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
  let!(:unit_bubble) { create(:unit_bubble, unit: unit) }
  let!(:child_unit) { create(:child_unit, parent: unit) }
  let!(:grandchild_unit) { create(:grandchild_unit, parent: child_unit) }

  describe 'on index page' do
    before do
      login_as(user, :scope => :user)
      visit units_path
    end

    it_behaves_like :units_tree_viewable

    context 'has no units manipulation rights' do
      it "doesn't display bubbles add button" do
        expect(page).to_not have_css ".m-tree-add"
      end

      it "has got one bubble at first" do
        expect(bubbles_amount).to eq(1)
      end

      it "shows correct info in bubble" do
        open_first_bubble
        within(".m-active") do
          expect(page).to have_css('.total-amount', text: "Всего 1 событие")
          expect(page).to have_css('.js-bubble-text', text: unit_bubble.comment)
        end
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

      describe "manipulates with bubbles" do
        it "creates new bubble" do
          expect { add_new_bubble }.to change(UnitBubble, :count)
        end

        it "deletes a bubble" do
          expect { delete_first_bubble }.to change(UnitBubble, :count)
        end
      end
    end
  end
end

# Returns number of bubbles on page
def bubbles_amount
  page.all(".js-bubble-open").count
end

# Opens first bubble
def open_first_bubble
  first(".js-bubble-open").click
end

# Performs action to add new bubble to first unit
def add_new_bubble
  first(".m-tree-add").click
  within(".m-active .js-add-bubble-form") do
    find("select").find(:xpath, 'option[2]').select_option
    fill_in 'unit_bubble[comment]', with: 'Bubble comment'
    click_button("Сохранить")
  end
  sleep(1)
end

# Performs action to delete a bubble from first unit
def delete_first_bubble
  open_first_bubble
  within(".m-active .bubbles-popover") do
    click_link("Удалить")
  end
  sleep(1)
end
