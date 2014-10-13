require 'acceptance_helper'

feature "User interacts with dashboard", no_private_pub: true do

  let(:user) { create(:user) }

  before  do
    login_as(user, scope: :user)
    visit users_root_path
  end

  describe "favourites block" do
    let(:css_block) { "_.favourites" }

    before do
      fav_two_units
    end

    it "displays correct favourite units in select" do
      within(css_block) do
        user.favourite_units.each do |unit|
          expect(find("option[value=#{unit}]").text).to eq(unit)
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
