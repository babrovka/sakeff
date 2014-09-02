require 'acceptance_helper'
require 'support/behaviours/units_tree_viewable'

feature "User manage broadcast messages", js: true do

  let(:messages) { create(:user) }
  let!(:unit) { create(:unit) }
  let!(:child_unit) { create(:child_unit) }
  let!(:grandchild_unit) { create(:grandchild_unit) }


  describe ''

end