require 'acceptance_helper'

feature "SuperUser view new Logs", %q() do

  let(:super_user) { create(:super_user) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let!(:organization) { create(:organization) }

  describe 'logs an autorization of user' do

    background do
      @old_logs = Log.count
      visit new_super_user_session_path
      fill_in 'super_user[email]', with: super_user.email
      fill_in 'super_user[password]', with: 'password'
      click_on 'Войти'
    end

    it 'added new log-item' do
      expect(Log.count).to_not eq @old_logs
      visit super_user_logs_path
      expect(page).to have_content 'Супер пользователь авторизовался'
      expect(page).to have_content super_user.label
    end

  end

  describe 'logs an edit organization' do
    background do
      @old_logs = Log.count
      login_as(super_user, :scope => :super_user)
      visit edit_super_user_organization_path(organization)
      fill_in 'organization[short_title]', with: 'new short title eahh!'
      click_on 'Сохранить'

    end

    it 'added new log-item' do
      expect(Log.count).to_not eq @old_logs
      visit super_user_logs_path
      expect(page).to have_content 'Организация изменена'
      expect(page).to have_content 'new short title eahh!'
    end

  end

  describe 'logs an create organization' do
    background do
      @old_logs = Log.count
      login_as(super_user, :scope => :super_user)
      visit new_super_user_organization_path
      fill_in 'organization[short_title]', with: 'new short title eahh!'
      fill_in 'organization[full_title]', with: 'new short title eahh!'
      fill_in 'organization[inn]', with: '123457890'
      select 'ИП', from: 'organization[legal_status]'
      click_on 'Создать'
    end

    it 'added new log-item' do
      expect(Log.count).to_not eq @old_logs
      visit super_user_logs_path
      expect(page).to have_content 'Организация создана'
    end

  end

  describe 'logs an edit user' do
    background do
      @old_logs = Log.count
      login_as(super_user, :scope => :super_user)
      visit edit_super_user_user_path(user)
      fill_in 'user[username]', with: 'new user username eahh!'
      click_on 'Сохранить'

    end

    it 'added new log-item' do
      expect(Log.count).to_not eq @old_logs
      visit super_user_logs_path
      expect(page).to have_content 'Пользователь изменен'
      expect(page).to have_content 'new user username eahh!'
    end

  end


  describe 'logs an create user' do
    background do
      @old_logs = Log.count
      login_as(super_user, :scope => :super_user)
      visit new_super_user_user_path

      fill_in 'user[username]', with: 'examplename'
      fill_in 'user[password]', with: 'killkill'
      fill_in 'user[password_confirmation]', with: 'killkill'

      fill_in 'user[last_name]', with: 'examplename1'
      fill_in 'user[first_name]', with: 'examplename2'
      fill_in 'user[middle_name]', with: 'examplename3'
      fill_in 'user[title]', with: 'popo'
      select organization.short_title, from: 'user[organization_id]'
      click_on 'Создать'

    end

    it 'added new log-item' do
      expect(Log.count).to_not eq @old_logs
      visit super_user_logs_path
      expect(page).to have_content 'Пользователь создан'
      expect(page).to have_content 'examplename'
    end

  end

  describe 'logs an create role' do
    background do
      @old_logs = Log.count
      login_as(super_user, :scope => :super_user)
    end

    xit do
      expect(Log.count).to_not eq @old_logs
    end
  end
  describe 'logs an edit role' do
    background do
      @old_logs = Log.count
      login_as(super_user, :scope => :super_user)
    end

    xit do
      expect(Log.count).to_not eq @old_logs
    end
  end

end