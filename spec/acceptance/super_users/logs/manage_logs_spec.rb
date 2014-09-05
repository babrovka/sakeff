require 'acceptance_helper'

feature "SuperUser view new Logs", %q(), js: true do

  let(:super_user) { create(:super_user) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let!(:organization) { create(:organization) }

  let(:log_path) { super_user_logs_path }
  let(:last_log) { Log.order('created_at DESC').first }

  describe 'Super user authorization logging' do

    scenario 'logged in' do
      old_logs_count = Log.count
      visit new_super_user_session_path
      fill_in 'super_user[email]', with: super_user.email
      fill_in 'super_user[password]', with: 'password'
      click_on 'Войти'

      expect(Log.count).to_not eq old_logs_count
      expect(last_log.event_type).to eq 'super_user_logged_in'
    end

    scenario 'logged out' do
      old_logs_count = Log.count
      login_as super_user, scope: :super_user
      visit destroy_super_user_session_path
      expect(Log.count).to_not eq old_logs_count
      expect(last_log.event_type).to eq 'super_user_logged_out'
    end

  end

  describe 'User authorization logging' do

    scenario 'logged in' do
      old_logs_count = Log.count
      visit new_user_session_path
      fill_in 'user[username]', with: user.username
      fill_in 'user[password]', with: 'password'
      click_on 'Войти'

      expect(Log.count).to_not eq old_logs_count
      expect(last_log.event_type).to eq 'user_logged_in'
      expect(last_log.result).to eq 'Success'
    end

    scenario 'logged out' do
      old_logs_count = Log.count
      login_as user, scope: :user
      visit destroy_user_session_path
      expect(Log.count).to_not eq old_logs_count
      expect(last_log.event_type).to eq 'user_logged_out'
      expect(last_log.result).to eq 'Success'
    end

    scenario 'wrong password' do
      old_logs_count = Log.count
      visit new_user_session_path
      fill_in 'user[username]', with: user.username
      fill_in 'user[password]', with: 'passwor'
      click_on 'Войти'

      expect(Log.count).to_not eq old_logs_count
      expect(last_log.event_type).to eq 'user_invalid_password'
      expect(last_log.result).to eq 'Error'
    end

    scenario 'user_unknown' do
      old_logs_count = Log.count
      visit new_user_session_path
      fill_in 'user[username]', with: 'user_unknown'
      fill_in 'user[password]', with: 'passwor'
      click_on 'Войти'

      expect(Log.count).to_not eq old_logs_count
      expect(last_log.event_type).to eq 'user_unknown'
      expect(last_log.result).to eq 'Error'
    end

  end

  describe 'Organization manage logging' do

    background do
      login_as(super_user, :scope => :super_user)
    end

    context 'organization created' do
      before do
        @old_logs_count = Log.count
        visit new_super_user_organization_path
        fill_in 'organization[short_title]', with: 'Org attr'
        fill_in 'organization[full_title]', with: 'Org attr'
        fill_in 'organization[inn]', with: '1234567890'
      end

      scenario 'success result' do
        select 'ООО', from: 'organization[legal_status]'
        click_on 'Создать'

        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'organization_created'
        expect(last_log.result).to eq 'Success'
      end

      scenario 'error result' do
        click_on 'Создать'

        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'organization_created'
        expect(last_log.result).to eq 'Error'
      end

    end

    context 'organization edited' do
      before do
        @old_logs_count = Log.count
        visit edit_super_user_organization_path(organization)
        fill_in 'organization[short_title]', with: 'Org attr new'
      end

      scenario 'success result' do
        click_on 'Сохранить'

        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'organization_edited'
        expect(last_log.result).to eq 'Success'
      end

      scenario 'error result' do
        fill_in 'organization[inn]', with: '1234'
        click_on 'Сохранить'

        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'organization_edited'
        expect(last_log.result).to eq 'Error'
      end

    end

    context 'organization deleted' do
      scenario 'success' do
        @old_logs_count = Log.count
        visit edit_super_user_organization_path(organization)
        click_on 'Удалить организацию'

        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'organization_deleted'
        expect(last_log.result).to eq 'Success'
      end

    end
  end

  describe 'User manage' do

    context 'user created' do
      background do
        @old_logs_count = Log.count
        login_as(super_user, :scope => :super_user)
        visit new_super_user_user_path
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        fill_in 'user[title]', with: 'job title'
        fill_in 'user[first_name]', with: 'name'
        fill_in 'user[last_name]', with: 'surname'
        fill_in 'user[middle_name]', with: 'dadovich'
        select organization.short_title, from: 'user[organization_id]'
      end

      scenario 'success' do
        fill_in 'user[username]', with: 'username_uniq'
        click_on 'Создать'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'user_created'
        expect(last_log.result).to eq 'Success'
      end

      scenario 'error' do
        click_on 'Создать'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'user_created'
        expect(last_log.result).to eq 'Error'
      end

    end

    context 'user edited' do
      background do
        @old_logs_count = Log.count
        login_as(super_user, :scope => :super_user)
        visit edit_super_user_user_path(user)


      end

      scenario 'success' do
        fill_in 'user[first_name]', with: 'first_name'
        click_on 'Сохранить'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'user_edited'
        expect(last_log.result).to eq 'Success'
      end

      scenario 'error' do
        fill_in 'user[password]', with: 'first_name'
        click_on 'Сохранить'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'user_edited'
        expect(last_log.result).to eq 'Error'
      end

    end

    context 'user deleted' do
      scenario 'success' do
        @old_logs_count = Log.count
        login_as(super_user, :scope => :super_user)
        visit edit_super_user_user_path(user)
        click_on 'Удалить пользователя'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'user_deleted'
        expect(last_log.result).to eq 'Success'
      end


    end


  end

  describe 'Role manage' do

    context 'role created' do
      background do
        @old_logs_count = Log.count
        login_as(super_user, :scope => :super_user)
        visit new_super_user_role_path
      end

      scenario 'success' do
        fill_in 'role[title]', with: 'role'
        fill_in 'role[description]', with: 'description'
        click_on 'Создать'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'role_created'
        expect(last_log.result).to eq 'Success'
      end

      scenario 'error' do
        click_on 'Создать'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'role_created'
        expect(last_log.result).to eq 'Error'
      end
    end

    context 'role edited' do
      background do
        @old_logs_count = Log.count
        login_as(super_user, :scope => :super_user)
        visit edit_super_user_role_path(role)
      end

      scenario 'success' do
        fill_in 'role[title]', with: 'role'
        fill_in 'role[description]', with: 'description'
        click_on 'Сохранить'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'role_edited'
        expect(last_log.result).to eq 'Success'
      end

      scenario 'error' do
        fill_in 'role[title]', with: ''
        fill_in 'role[description]', with: ''
        click_on 'Сохранить'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'role_edited'
        expect(last_log.result).to eq 'Error'
      end
    end

    context 'role deleted' do

      scenario 'success' do
        @old_logs_count = Log.count
        login_as(super_user, :scope => :super_user)
        visit edit_super_user_role_path(role)
        click_on 'Удалить роль'
        expect(Log.count).to_not eq @old_logs_count
        expect(last_log.event_type).to eq 'role_deleted'
        expect(last_log.result).to eq 'Success'
      end

    end
  end

end