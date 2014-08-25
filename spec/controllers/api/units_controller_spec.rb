require 'acceptance_helper'
require 'spec_helper'
require 'rails_helper'
include Devise::TestHelpers

describe Api::UnitsController, :type => :controller do
  describe "GET index", units: true do
    render_views # for jbuilder

    let(:super_user) { create(:super_user) }
    let!(:unit) { create(:unit) }
    let!(:child_unit) { create(:child_unit) }
    let!(:grandchild_unit) { create(:grandchild_unit) }

    before { sign_in :super_user, super_user }

    it "gets all units" do
      get :index, { format: :json }

      expected_response = Unit.all.map do |unit|
        { id: unit.id, parent: (unit.parent.try(:id) || '#'), text: unit.label, children: unit.children.any?, bubbles: [], tree_has_bubbles: false }
      end.to_json
      expect(response.body).to eq expected_response
    end
  end
end
