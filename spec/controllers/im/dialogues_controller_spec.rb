require 'acceptance_helper'
require 'spec_helper'
require 'rails_helper'

describe Im::DialoguesController, :type => :controller do
  describe "GET index", dialogues: true do

    let(:user) { create(:user) }
    let(:user_with_access) do
      user.set_permission(:read_organization_messages, :granted)
      user
    end

    subject { get :index }

    context "user without permissions" do
      before { sign_in user }

      it "redirects to index" do
        expect(subject).to redirect_to(users_root_path)
      end
    end

    context "user without permissions" do
      before { sign_in user_with_access }

      it "redirects to index" do
        expect(subject).to render_template :index
      end
    end
  end
end
