require 'acceptance_helper'
require 'support/behaviours/permit_form_checkboxable'
include Features::PermitFormMethods


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

    it_behaves_like :permit_form_checkboxable

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


  # describe "User interacts with a permits list" do
  #   context "User has got permissions" do
  #     before do
  #       login_as(user, scope: :user)
  #       visit permits_path(type: :human)
  #     end
  #
  #     describe "User can interact with not expired permits" do
  #       scenario "User clicks on a permit and makes it inactive" do
  #         first_permit = page.first(".block-table__tr")
  #         within first_permit do
  #           page.find(".label-sea-green").click
  #           sleep(1)
  #         end
  #         expect(page.find)
  #
  #       end
  #
  #       scenario "User clicks on a print link and sees a pdf" do
  #
  #       end
  #
  #       scenario "User can see an edit and a create link" do
  #
  #       end
  #     end
  #
  #
  #     # describe "User cannot interact with expired permits" do
  #     #   scenario "User can see inactive permits" do
  #     #
  #     #   end
  #     #
  #     #   scenario "User can't click on an expired permit" do
  #     #
  #     #   end
  #     # end
  #   end
  #
  #
  #   # context "User doesn't have edit permissions" do
  #   #   before do
  #   #     login_as(viewer_user, scope: :user)
  #   #     visit permits_path
  #   #   end
  #   #
  #   #   describe "User can't change permits" do
  #   #     scenario "User can't make permit inactive" do
  #   #
  #   #     end
  #   #
  #   #     scenario "User can't see an edit or create link" do
  #   #
  #   #     end
  #   #
  #   #     scenario "User clicks on a print link and sees a pdf" do
  #   #
  #   #     end
  #   #   end
  #   # end
  # end
end
