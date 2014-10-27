require 'acceptance_helper'

feature "User manages permits" do
  let(:user) do
    user = create(:user)
    user.set_permission(:view_permits, :granted)
    user.set_permission(:edit_permits, :granted)
    user
  end
  let(:permit) { create(:permit, :not_expired) }
  let(:permit_two) { create(:permit, :not_expired) }

  before { login_as(user, scope: :user) }


  describe "User uses a permits form to create a new permit" do
    before { visit new_permit_path }

    context "On initial page load" do
      describe "car inputs" do
        context "user didn't click on car type" do
          scenario "User cannot edit car inputs" do

          end
        end

        context "user clicked on car type" do
          scenario "allows user to edit car inputs" do

          end
        end
      end


      describe "once inputs" do
        context "user didn't click on once type" do
          scenario "doesn't allow user to edit once inputs" do

          end

          it "can choose starts_at date" do

          end
        end


        context "user clicked on once type" do
          scenario "allows user to edit once inputs" do

          end

          it "can't choose starts_at date" do

          end
        end
      end
    end



    context "During saving process" do
      describe "car inputs" do
        context "user didn't click on car type" do
          scenario "doesn't set car fields" do

          end
        end

        context "user clicked on car type" do
          scenario "sets car fields" do

          end
        end
      end


      describe "once inputs" do
        context "user didn't click on once type" do
          scenario "doesn't set once fields" do

          end
        end

        context "user clicked on once type" do
          scenario "sets once fields" do

          end
        end
      end
    end
  end

  describe "User uses a permits form to edit an existing permit" do
    # TODO: repeat same tests for edit/update actions and probably make a shared example
  end


  describe "User interacts with a permits list" do
    describe "User cannot interact with expired permits" do
       scenario "User can see inactive permits" do

       end

       scenario "User can't click on an expired permit" do

       end
    end


    describe "User can interact with not expired permits" do
      scenario "User clicks on a permit and makes it inactive" do

      end

      scenario "User clicks on a print link and sees a pdf" do

      end

    end
  end
end
