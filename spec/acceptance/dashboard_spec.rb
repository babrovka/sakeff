require 'acceptance_helper'

feature "User interacts with dashboard", js: true, no_private_pub: true do

  let(:user) { create(:user) }
  let(:unit) { create(:unit) }

  let!(:first_faved_unit) do
    unit = create(:unit)
    unit.favourite_for_user(user)
  end

  let!(:second_faved_unit) do
    unit = create(:unit)
    unit.favourite_for_user(user)
  end

  before  do
    login_as(user, scope: :user)
  end

  describe "favourites block" do
    subject { "._favourites" }

    before do
      expect(user.favourite_units.count).to eq(2)
      visit users_root_path
    end

    it "displays correct favourite units in select" do
      within(subject) do
        user.units.each do |unit|
          expect(page).to have_css("option[value='#{unit.id.upcase}']")
        end
      end
    end

    it "doesn't display other units in select" do
      within(subject) do
        expect(page).not_to have_css("option[value='#{unit.id.upcase}']")
      end
    end
  end
end
