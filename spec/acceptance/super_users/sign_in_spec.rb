require 'acceptance_helper'

feature "SuperUser sign in and sign out", %q() do

  let!(:super_user) { create(:super_user) }
  let(:path) { super_user_root_path }

  describe 'Super user sign in' do
    before do
      visit path
      expect(current_path).to eq new_super_user_session_path
    end

    it 'success' do
      fill_in 'super_user[email]', with: super_user.email
      fill_in 'super_user[password]', with: 'password'
      click_on 'Войти'
      expect(current_path).to eq path
    end

    it 'failed' do
      fill_in 'super_user[email]', with: super_user.email
      fill_in 'super_user[password]', with: 'pass2word'
      click_on 'Войти'
      expect(page).to have_content 'Неверное имя пользователя или пароль.'
      expect(current_path).to_not eq root_path
    end

  end
end

