require 'acceptance_helper'
require 'spec_helper'
require 'rails_helper'

describe PermitsController, type: :controller do
  describe "GET show", permits: true do

    let(:permit) { create(:permit) }
    let(:user) { create(:user) }
    let(:user_with_access) do
      user.set_permission(:view_permits, :granted)
      user
    end

    context "user without permissions" do
      before { sign_in user }

      it "redirects to index" do
        get :show, id: permit

        expect(response).to redirect_to(root_path)
      end
    end


    context "user with permissions" do
      before { sign_in user_with_access }

      describe "wrong type" do
        it "redirects to root" do
          get :show, id: permit

          expect(response).to redirect_to(root_path)
        end
      end

      describe "correct type" do
        it "shows a car pdf" do
          get :show, id: permit, type: "car"


          expect(response.body[0, 4]).to eq('%PDF')
        end

        it "shows a once pdf" do
          get :show, id: permit, type: "once"

          expect(response.body[0, 4]).to eq('%PDF')
        end

        it "shows a human pdf" do
          get :show, id: permit, type: "human"

          expect(response.body[0, 4]).to eq('%PDF')
        end
      end
    end
  end
end
