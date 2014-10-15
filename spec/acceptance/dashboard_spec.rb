require 'acceptance_helper'

feature "User interacts with dashboard", js: true, no_private_pub: true do

  let(:user) { create(:user) }
  let(:unit) { create(:unit) }

  before do
    login_as(user, scope: :user)
  end

  describe "favourites block" do
    let!(:first_faved_unit) do
      unit = create(:unit)
      unit.favourite_for_user(user)
    end

    let!(:second_faved_unit) do
      unit = create(:unit)
      unit.favourite_for_user(user)
    end

    let(:select_placeholder) { "Выберите объект" }

    subject { "._favourites" }

    before do
      expect(user.favourite_units.count).to eq(2)
      visit users_root_path
    end

    # describe "favourites select" do
    #   it "displays correct favourite units" do
    #     within(subject) do
    #       user.units.each do |unit|
    #         expect(page).to have_css(option_of_unit(unit))
    #       end
    #     end
    #   end
    #
    #   it "doesn't display other units" do
    #     within(subject) do
    #       expect(page).not_to have_css(option_of_unit(unit))
    #     end
    #   end
    # end


    describe "bubbles creation buttons" do
      context "no units are selected" do
        before do
          within(subject) do
            expect(favourite_select_value).to eq select_placeholder
          end
        end

        it "doesn't open a form when no units are selected" do
          # save_and_open_page

          # find("#restrictions__rating_movies").value
        end
      end

      context "a unit is selected" do
        before do
          within(subject) do
            select_option_by_number(2)

            expect(favourite_select_value).to_not eq select_placeholder
          end
        end

        it "opens a form on click" do

        end

        # context "user didn't write text in a bubble text field" do
        #   it "doesn't create a bubble on submit" do
        #     pending "there are no validations yet"
        #
        #   end
        # end
        #
        # context "user wrote text in a bubble text field" do
        #   it "creates a bubble on submit" do
        #
        #   end
        # end
      end
    end
  end
end


# Returns HTML option of a certain unit
# @param unit [Unit]
# @note is used in favourites block tests
def option_of_unit(unit)
  "option[value='#{unit.id.upcase}']"
end


# Returns value of a favourite select
# @note is used in favourites block tests
def favourite_select_value
  find("select").value
end


# Selects an option inside favourite select
# @param number [Integer]
# @note is used in favourites block tests
def select_option_by_number(number)
  find("select").find(:xpath, "option[#{number}]").select_option
end
