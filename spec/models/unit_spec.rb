require 'rails_helper'

describe Unit do
  let(:unit) { create(:unit) }

  describe "favourites" do
    let(:user) { create(:user) }

    describe '#favourite_for_user' do
      subject { unit.favourite_for_user(user) }

      it "adds a unit to a list of favourite user units" do
        expect { subject }.to change(user.units, :count)
      end
    end

    describe '#is_favourite_of_user?' do
      subject { unit.is_favourite_of_user?(user) }

      context "user hasn't faved this unit yet" do
        it "indicates that this unit is not a user's favourite" do
          expect(subject).to be_falsey
        end
      end

      context "user has already faved this unit" do
        before { unit.favourite_for_user(user) }

        it "indicates that this unit is a user's favourite" do
          expect(subject).to be_truthy
        end
      end
    end
  end

end
