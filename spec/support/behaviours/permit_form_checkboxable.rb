# Tests whenever users can interact with checkboxes on permits form
# @note is used in acceptance/permits_spec
shared_examples :permit_form_checkboxable do
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
