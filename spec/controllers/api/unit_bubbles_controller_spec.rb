require 'acceptance_helper'
require 'spec_helper'
require 'rails_helper'
include Devise::TestHelpers

describe Api::UnitBubblesController, :type => :controller do
  describe "GET nested_bubbles_amount", units: true do
    render_views # for jbuilder

    let(:super_user) { create(:super_user) }
    let!(:unit) { create(:unit) }
    let!(:child_unit) { create(:child_unit, parent: unit) }
    let!(:grandchild_unit) { create(:grandchild_unit, parent: child_unit) }

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

      grandchild_unit_bubbles_count = grandchild_unit.bubbles.size
      child_unit_bubbles_count = grandchild_unit_bubbles_count + child_unit.bubbles.size
      unit_bubbles_count = child_unit_bubbles_count + unit.bubbles.size
      unit_bubble = unit.bubbles.first

      bubble_type = unit_bubble.bubble_type
      unit_bubble_type = UnitBubble.bubble_types[bubble_type]
      russian_name = UnitBubble.bubble_type_russian_name(bubble_type)

      expected_response = [
        {
          unit_id: unit.id.upcase,
          bubbles: {"#{unit_bubble_type}" => { name: bubble_type, russian_name: russian_name, count: unit_bubbles_count}}
        },
        {
          unit_id: child_unit.id.upcase,
          bubbles: {"#{unit_bubble_type}" => { name: bubble_type, russian_name: russian_name, count: child_unit_bubbles_count}}
        },
        {
          unit_id: grandchild_unit.id.upcase,
          bubbles: {"#{unit_bubble_type}" => { name: bubble_type, russian_name: russian_name, count: grandchild_unit_bubbles_count }}
        }
      ].to_json

      expect(response.body).to eq expected_response
    end
  end
end
