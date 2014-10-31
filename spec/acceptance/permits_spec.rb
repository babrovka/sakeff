require 'acceptance_helper'

feature "User manages permits" do
  let(:user) do
    user = create(:user)
    user.set_permission(:view_permits, :granted)
    user.set_permission(:edit_permits, :granted)
    user
  end
  let(:viewer_user) do
    user = create(:user)
    user.set_permission(:view_permits, :granted)
    user
  end
  let(:permit) { create(:permit, :not_expired) }
  let(:permit_two) { create(:permit, :not_expired) }


  describe "User uses a permits form to create a new permit", js: true do
    before do
      login_as(user, scope: :user)
      visit new_permit_path
    end

    describe "Car inputs" do
      context "User didn't click on car type" do
        scenario "User cannot edit car inputs" do
          expect(page).to have_field car_input, disabled: true
        end
      end

      context "User clicked on car type" do
        scenario "User can edit car inputs" do
          toggle_car_type
          expect(page).to have_field car_input, disabled: false
        end
      end
    end


    describe "Once inputs" do
      context "user didn't click on once type" do
        scenario "doesn't allow user to edit once inputs" do
          expect(page).to have_field once_input, disabled: true
        end

        scenario "User can choose starts_at date" do
          expect(page).to have_field starts_at_input, disabled: false
        end
      end


      context "User clicked on once type" do
        before { toggle_once_type }

        scenario "allows user to edit once inputs" do
          expect(page).to have_field once_input, disabled: false
        end

        scenario "User can't choose starts_at date" do
          expect(page).to have_field starts_at_input, disabled: true
        end
      end
    end
  end


  pending "User interacts with a permits list" do
    context "User has got permissions" do
      before do
        login_as(user, scope: :user)
        visit permits_path
      end


      describe "User can interact with not expired permits" do
        scenario "User clicks on a permit and makes it inactive" do

        end

        scenario "User clicks on a print link and sees a pdf" do

        end

        scenario "User can see an edit and a create link" do

        end
      end


      describe "User cannot interact with expired permits" do
        scenario "User can see inactive permits" do

        end

        scenario "User can't click on an expired permit" do

        end
      end
    end


    context "User doesn't have edit permissions" do
      before do
        login_as(viewer_user, scope: :user)
        visit permits_path
      end

      describe "User can't change permits" do
        scenario "User can't make permit inactive" do

        end

        scenario "User can't see an edit or create link" do

        end

        scenario "User clicks on a print link and sees a pdf" do

        end
      end
    end
  end
end


def car_input
  "permit_car_brand"
end

def once_input
  "permit_location"
end

def starts_at_input
  "permit[starts_at]"
end


def fill_form_by_permit(permit)
  %w(first_name last_name middle_name doc_number expires_at).each do |field|
    fill_in "permit[#{field}]", with: permit.send(field.to_sym)
  end
end

def submit_create_form
  click_button "Создать"
end


def toggle_car_type
  trigger_custom_checkbox("permit_car")
end

def toggle_once_type
  trigger_custom_checkbox("permit_once")
end

def trigger_custom_checkbox(checkbox_id)
  page.find("##{checkbox_id}").trigger('click')
end
