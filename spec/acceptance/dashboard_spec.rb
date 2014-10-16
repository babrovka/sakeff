require 'acceptance_helper'

feature "User interacts with dashboard", js: true, no_private_pub: true do
  let(:user) do
    user = create(:user)
    user.set_permission(:manage_unit_status, :granted)
    user
  end
  let(:unit) { create(:unit) }

  before do
    login_as(user, scope: :user)
  end

  describe "on favourites block" do
    let!(:first_faved_unit) do
      unit = create(:unit, label: "First unit")
      unit.favourite_for_user(user)
      unit
    end

    let!(:second_faved_unit) do
      unit = create(:unit)
      unit.favourite_for_user(user)
      unit
    end

    let(:select_placeholder) { "Выберите объект" }

    subject { "._favourites" }

    before do
      expect(user.favourite_units.count).to eq(2)
      visit users_root_path
    end


    describe "favourites select" do
      it "displays correct favourite units" do
        within(subject) do
          user.units.each do |unit|
            expect(page).to have_css(option_of_unit(unit))
          end
        end
      end

      it "doesn't display other units" do
        within(subject) do
          expect(page).not_to have_css(option_of_unit(unit))
        end
      end
    end


    describe "bubbles creation buttons" do
      context "no units are selected" do
        before do
          within(subject) do
            expect(favourite_select_value).to eq select_placeholder
          end
        end

        it "doesn't open a form when no units are selected" do
          within(subject) do
            click_on_bubble_button
          end
          expect(page).not_to have_css(bubble_form_popover)
        end
      end

      context "a unit is selected" do
        before do
          within(subject) do
            select first_faved_unit.label, from: "favourite_unit_id"
            click_on_bubble_button
          end
        end

        it "opens a form on click" do
          expect(page).to have_css(bubble_form_popover)
        end

        it "displays a unit name" do
          within(".m-active.js-react-popover-component") do
            expect(page).to have_content first_faved_unit.label
          end
        end

        context "user wrote text in a bubble text field" do
          it "creates a bubble on submit" do
            expect do
              within(".m-active.js-react-popover-component") do
                fill_in 'unit_bubble[comment]', with: 'lorem'
                click_on "Сохранить"
                sleep(1)
              end
            end.to change(UnitBubble, :count)
          end
        end
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


# Clicks on a bubble add button
# @note is used in favourites block tests
def click_on_bubble_button
  find("._favourites__button--emergency").click
end


# CSS selector of a bubble form popover
# @note is used in favourites block tests
def bubble_form_popover
  "._favourites__button--emergency.m-popover-shown"
end
