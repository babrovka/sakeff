require 'acceptance_helper'

feature "SuperUser manage User", %q() do

  let!(:super_user) { create(:super_user) }
  let!(:user) { create(:user) }
  let!(:old_user_username) { user.username }
  let(:path) { super_user_root_path }

  background do
    login_as(super_user, :scope => :super_user)
    visit edit_super_user_user_path(user)
    fill_in 'user[username]', with: 'examplename'
  end

  describe 'Edit user' do
    context 'with valid attributes' do
      scenario 'success update' do
        expect { click_on 'Сохранить' }.to_not change(User, :count)
        expect(current_path).to eq super_user_users_path
        # проверяем,что параметр изменился в БД
        user.reload
        expect(user.username).to_not eq old_user_username
      end
    end

    context 'without valid attributes' do
      scenario 'failed update' do
        # по сценарию, пароль должен быть длинее 8 символов
        new_pass = '123456'
        fill_in 'user[password]', with: new_pass
        fill_in 'user[password_confirmation]', with: new_pass
        expect { click_on 'Сохранить' }.to_not change(User, :count)
        user.reload
        expect(current_path).to_not eq super_user_users_path
      end
    end
  end
end

