require 'acceptance_helper'
include Features::PermitFormMethods
include Features::PermitListMethods

feature "User manages permits", js: true, slow: true, fast: false do
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
  let!(:human_permit) { create(:permit, :not_expired, :human) }
  let!(:car_permit) { create(:permit, :not_expired, :car) }



  describe "User uses a permits form to create a new permit" do
    before do
      login_as(user, scope: :user)
      visit new_permit_path
    end

    it_behaves_like :permit_form_checkboxable
  end


  describe "User uses a permits form to update a permit" do
    before do
      login_as(user, scope: :user)
      visit edit_permit_path(car_permit)
    end

    scenario "User switches car permit to a human" do
      toggle_car_type
      submit_edit_form(car_permit)

      expect(car_permit.car).to be_falsy
      expect(car_permit.region).to eq("")
      expect(car_permit.human).to be_truthy
    end

    scenario "User switches car permit to a once" do
      toggle_car_type
      toggle_once_type
      fill_once_fields
      submit_edit_form(car_permit)

      expect(car_permit.region).to eq("")
      expect(car_permit.once).to be_truthy
      expect(car_permit.car).to be_falsy
    end
  end


  describe "User interacts with a permits list" do
    context "User has got permissions" do
      before do
        login_as(user, scope: :user)
        visit scope_permits_path(type: "human")
      end


      describe "User can print multiple documents" do
        it "makes a print link clickable after selecting several permits" do
          expect(page).to have_css disabled_mass_print_button

          trigger_print_checkbox(human_permit)
          trigger_print_checkbox(car_permit)
          click_on_mass_print_button

          expect(page).to_not have_css disabled_mass_print_button
        end
      end


      # Commented because popover is buggy
      # describe "User can interact with not expired permits" do
      #   scenario "User clicks on a print link and sees a pdf" do
      #     open_popover(car_permit)
      #     click_on_print_permit
      #   end
      #
      #   scenario "User clicks on a permit and makes it inactive" do
      #     disactivate_permit(car_permit)
      #
      #     expect(car_permit.expired?).to be_truthy
      #   end
      # end
      #
      #
      # describe "User cannot interact with expired permits" do
      #   scenario "User can't click on an expired permit" do
      #     disactivate_permit(human_permit)
      #     try_to_open_popover(human_permit)
      #
      #     expect(page).not_to have_css ".m-active .js-permit-print-popover"
      #   end
      # end
    end
  end
end
