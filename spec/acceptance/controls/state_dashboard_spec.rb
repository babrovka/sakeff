require 'acceptance_helper'

feature "User manage control state in dashboard", %q() do


  let!(:user) { create(:user) }
  let!(:allowed_user) do
    user = create(:user)
    user.permissions << Permission.where(title: 'manage_operation_mode').first
    up = user.user_permissions.where(permission: Permission.where(title: :manage_operation_mode)).first
    up.result = :granted
    up.save!
    user
  end


  let!(:normal_state) { create(:control_state, :is_normal) }
  let!(:bad_state) { create(:control_state) }
  let!(:states){ [normal_state, bad_state] }

  let!(:eve){ Control::Eve.instance }

  let(:path) { control_dashboard_path }

  describe 'Render only for allowed users' do
    scenario 'failed' do
      login_as user, scope: :user
      visit path

      expect(current_path).to_not eq path
      expect(current_path).to eq control_dashboard_clean_path
    end


    scenario 'success' do
      login_as allowed_user, scope: :user
      visit path

      expect(current_path).to eq path
    end
  end

  describe 'Change states', js: true do

    background do
      login_as allowed_user, scope: :user
      visit path

    end

    context 'toggle states' do
      context 'from normal state' do
        scenario 'toggle to normal state' do
          old_state = eve.overall_state
          expect(old_state).to eq true

          click_on normal_state.name

          new_state = eve.overall_state
          expect(new_state).to eq old_state
        end

        scenario 'toggle to bad state' do
          eve.change_global_state_to bad_state

          old_state = eve.overall_state
          expect(old_state).to eq false

          click_on bad_state.name

          new_state = eve.overall_state
          expect(new_state).to eq old_state
        end
      end


    end

  end
end

