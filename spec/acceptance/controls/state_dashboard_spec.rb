require 'acceptance_helper'

feature "User manage control state in dashboard", %q() do

  let!(:user) { create(:user) }
  let!(:allowed_user) do
    user = create(:user)
    user.set_permission(:access_dispatcher, :granted)
    user
  end

  let!(:normal_state) { create(:control_state, :is_normal) }
  let!(:bad_state) { create(:control_state) }
  let!(:states){ [normal_state, bad_state] }

  let!(:eve){ Control::Eve.instance }
  let(:path) { control_dashboard_path }

  background do
    Control::Eve.instance.reset
  end

  describe 'Control states widgets', js: true do
    context 'for regular user' do
      scenario 'will not render' do
        login_as user, scope: :user
        visit path

        expect(current_path).to_not eq path
        expect(current_path).to eq control_dashboard_clean_path
      end
    end

    context 'for allowed user' do
      scenario 'will render current state' do
        login_as allowed_user, scope: :user
        visit path
        create_screenshot

        expect(current_path).to eq path
        expect(page).to have_content normal_state.name
        expect(page).to_not have_content bad_state.name
      end
    end
  end

  describe 'Change states', js: true do

    background do
      login_as allowed_user, scope: :user
      allowed_user.set_permission(:manage_operation_mode, :granted)
      visit path
    end

    context 'toggle states' do
      context 'from normal state' do
        scenario 'toggle to bad state' do
          old_state = eve.overall_state
          expect(old_state).to eq true

          click_on bad_state.name
          sleep 0.5
          new_state = eve.overall_state
          expect(new_state).to_not eq old_state
        end
      end


    end

  end
end

