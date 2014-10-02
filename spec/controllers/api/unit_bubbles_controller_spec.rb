require 'acceptance_helper'
require 'spec_helper'
require 'rails_helper'
include Devise::TestHelpers

describe Api::UnitBubblesController, :type => :controller do
  describe "GET nested_bubbles_amount", units: true do
    render_views # for jbuilder

    let(:super_user) { create(:super_user) }
    let!(:unit) { create(:unit) }
    let!(:child_unit) { create(:child_unit) }
    let!(:grandchild_unit) { create(:grandchild_unit) }

    before do
      sign_in :super_user, super_user

      3.times do
        create(:unit_bubble, unit: unit)
        create(:unit_bubble, unit: grandchild_unit)
      end

      2.times do
        create(:unit_bubble, unit: child_unit)
      end
    end

    it "gets all nested bubbles" do
      get :nested_bubbles_amount, { format: :json }

      expected_response = [{:unit_id=>unit.id.upcase,
        :bubbles=>{:"1"=>{:name=>"work", :russian_name=>"Работы", :count=>"8"}}},
       {:unit_id=>child_unit.id.upcase,
        :bubbles=>{:"1"=>{:name=>"work", :russian_name=>"Работы", :count=>"5"}}},
       {:unit_id=>grandchild_unit.id.upcase,
        :bubbles=>{:"1"=>{:name=>"work", :russian_name=>"Работы", :count=>"2"}}}].to_json

      expect(response.body).to eq expected_response
    end
  end
end
