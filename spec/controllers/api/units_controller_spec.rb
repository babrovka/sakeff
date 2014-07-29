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

    it "gets a root unit" do
      get :index, { format: :json }

      expected_response = [{ id: unit.id, text: unit.label, children: true}].to_json
      expect(response.body).to eq expected_response
    end

    it "gets a children unit" do
      get :index, { id: unit.id, format: :json }

      expected_response = [{ id: child_unit.id, text: child_unit.label, children: true}].to_json
      expect(response.body).to eq expected_response
    end

  end
end