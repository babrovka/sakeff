require 'acceptance_helper'

feature "SuperUser create User", %q() do

  let!(:super_user) { create(:super_user) }
  let(:path) { super_user_root_path }
  let!(:organization) { create(:organization) }

  background do
    login_as(super_user, :scope => :super_user)
    visit new_super_user_user_path
    new_pass = '12345678'
    fill_in 'user[username]', with: 'examplename'
    fill_in 'user[password]', with: new_pass
    fill_in 'user[password_confirmation]', with: new_pass

    fill_in 'user[last_name]', with: 'examplename1'
    fill_in 'user[first_name]', with: 'examplename2'
    fill_in 'user[middle_name]', with: 'examplename3'
    fill_in 'user[title]', with: 'popo'
    select organization.short_title, from: 'user[organization_id]'
  end

  describe 'Create user' do
    context 'with valid attributes' do
      scenario 'success update' do
        expect { click_on 'Создать' }.to change(User, :count)
        expect(current_path).to eq super_user_users_path

      end
    end
  end
end

