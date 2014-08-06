require 'acceptance_helper'

feature "User manage global state dashboard", %q() do

  let!(:user) { create(:user) }
  let!(:allowed_user) do
    user = create(:user)
    user.permissions << create(:permission, title: 'supervisor')
    user
  end

  let(:path) { control_dashboard_path }

  describe 'Render only for allowed users' do
    scenario 'failed' do
      login_as user, scope: :user
      visit path

      expect(current_path).to_not eq path
      expect(current_path).to eq users_root_path
    end


    it 'success' do
      login_as allowed_user, scope: :user
      visit path

      expect(current_path).to eq path
    end
  end

  describe 'Change states' do

    background do
      login_as allowed_user, scope: :user
      visit path
    end

    context 'all good actions' do
      scenario 'active state' do
        old_count = 0
        new_count = 0
        click_on 'Все хорошо'
        expect(new_count).to_not eq old_count
      end

      scenario 'deactive state' do
        old_count = 0
        new_count = 0
        click_on 'Все хорошо'
        sleep 1
        click_on 'Все хорошо'
        expect(new_count).to_not eq old_count
      end
    end

    context 'all bad actions' do
      scenario 'active state' do
        old_count = 0
        new_count = 0
        click_on 'Все плохо'
        expect(new_count).to_not eq old_count
      end

      scenario 'deactive state' do
        old_count = 0
        new_count = 0
        click_on 'Все плохо'
        sleep 1
        click_on 'Все плохо'
        expect(new_count).to_not eq old_count
      end
    end

  end
end

