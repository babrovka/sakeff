require 'acceptance_helper'

feature "User sign in and sign out", %q() do

  let!(:user) { create(:user) }
  let(:path) { control_dashboard_clean_path }

  describe 'Super user sign in' do

    context 'without authorization' do
      scenario 'show public page' do
        visit root_path
        expect(current_path).to eq root_path
        expect(page).to have_content 'Авторизация'
      end

      scenario 'deny to access user dashboard' do
        visit path
        expect(current_path).to_not eq path
      end
    end

    context 'with authorization' do
      before do
        visit path

        fill_in 'user[username]', with: user.username
        fill_in 'user[password]', with: 'password'
        click_on 'Войти'
      end

      scenario 'show user dashboard' do
        expect(current_path).to eq path
      end

      scenario 'deny to open public page' do
        visit root_path
        expect(current_path).to_not eq root_path
        expect(current_path).to eq path
      end
    end

  end
end

