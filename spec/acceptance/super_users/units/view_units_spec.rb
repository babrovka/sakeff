require 'acceptance_helper'
require 'support/behaviours/units_tree_viewable'

feature "SuperUser interacts with units", js: true, units: true do
  let(:super_user) { create(:super_user) }
  let!(:unit) { create(:unit) }
  let!(:child_unit) { create(:child_unit, parent: unit) }
  let!(:grandchild_unit) { create(:grandchild_unit, parent: child_unit) }

  describe 'on index page' do
    before do
      login_as(super_user, scope: :super_user)
      visit super_user_units_path
    end

    it_behaves_like :units_tree_viewable
  end
end
