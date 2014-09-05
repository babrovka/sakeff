require 'acceptance_helper'
require 'support/behaviours/units_tree_viewable'

feature "User interacts with units", js: true, units: true do

  let(:super_user) { create(:super_user) }
  let!(:unit) { create(:unit) }
  let!(:child_unit) { create(:child_unit, parent: unit) }
  let!(:grandchild_unit) { create(:grandchild_unit, parent: child_unit) }

  describe 'on index page' do
    before do
      login_as(user, :scope => :user)
      visit units_path
    end

    pending("Because phantomjs doesn't support webgl") do
      it_behaves_like :units_tree_viewable
    end

  end
end