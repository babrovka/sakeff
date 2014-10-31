require 'acceptance_helper'
require 'spec_helper'
require 'rails_helper'

describe PermitsController, type: :controller, permits: true do
  let(:permit) { create(:permit, :not_expired) }
  let(:expired_permit) do
    permit = create(:permit)
    permit.expires_at = (Time.now - 1.day)
    permit.save
    permit
  end

  let(:user) { create(:user) }
  let(:user_with_view_permit) do
    user = create(:user)
    user.set_permission(:view_permits, :granted)
    user
  end
  let(:user_with_edit_permit) do
    user = create(:user)
    user.set_permission(:view_permits, :granted)
    user.set_permission(:edit_permits, :granted)
    user
  end


  describe "GET index" do
    subject { get :index, type: :human }

    context "user without permissions" do
      before { sign_in user }

      it "redirects to index" do
        expect(subject).to redirect_to(root_path)
      end
    end


    context "user with view permissions" do
      before { sign_in user_with_view_permit }

      it "shows permits index" do
        expect(subject).to render_template :index
      end
    end
  end


  describe "DELETE destroy" do
    subject { delete :destroy, id: permit }

    context "user without permissions" do
      before { sign_in user }

      it "redirects to index" do
        expect(subject).to redirect_to(root_path)
      end
    end


    context "user with edit permissions" do
      before { sign_in user_with_edit_permit }

      it "Displays delete alert" do
        subject
        expect(flash[:alert]).to eq "Пропуск успешно удален"
      end
    end
  end



  describe "GET new" do
    subject { get :new }

    context "user without permissions" do
      before { sign_in user }

      it "redirects to index" do
        expect(subject).to redirect_to(root_path)
      end
    end


    context "user with edit permissions" do
      before { sign_in user_with_edit_permit }

      it "shows permits creation form" do
        expect(subject).to render_template :new
      end
    end
  end



  describe "GET edit" do
    context "permit is not expired" do
      subject { get :edit, id: permit }

      context "user without permissions" do
        before { sign_in user }

        it "redirects to index" do
          expect(subject).to redirect_to(root_path)
        end
      end


      context "user with edit permissions" do
        before { sign_in user_with_edit_permit }

        it "shows permits edit form" do
          expect(subject).to render_template :edit
        end
      end
    end


    context "permit is expired" do
      subject { get :edit, id: expired_permit }
      before { sign_in user_with_edit_permit }

      it "redirects to permits page" do
        expect(subject).to redirect_to(permits_path)
      end
    end
  end


  describe "GET show" do
    context "user without permissions" do
      before { sign_in user }

      it "redirects to index" do
        get :show, id: permit

        expect(response).to redirect_to(root_path)
      end
    end


    context "user with permissions" do
      before { sign_in user_with_view_permit }

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
