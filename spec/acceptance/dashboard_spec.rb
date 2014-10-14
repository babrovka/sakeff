require 'acceptance_helper'

feature "User interacts with dashboard", js: true, no_private_pub: true do

  let(:user) { create(:user) }

  before  do
    login_as(user, scope: :user)
  end

  describe "favourites block" do
    subject { "._favourites" }

    before do
      fav_two_units
      visit users_root_path
    end

    it "displays correct favourite units in select" do
      within(subject) do
        user.units.each do |unit|
          expect(page).to have_css("option[value='#{unit.id.upcase}']")
        end
      end
    end
  end
end


# Creates 10 units and favs 2 of them
# @note is called for a favourites block test
# @note checks itself in the end
def fav_two_units
  units = []
  10.times do
    units << create(:unit)
  end
  units.first.favourite_for_user(user)
  units.last.favourite_for_user(user)

  expect(user.favourite_units.count).to eq(2)
end
