require 'acceptance_helper'

feature "SuperUser manages Roles" do

  let(:super_user) { create(:super_user) }
  let(:permission) { create(:permission) }
  let(:invalid_attribute) { '' }
  let(:role_title) { 'Новая роль' }
  let!(:role) { create(:role) }
  let!(:old_role_description) { role.description }

  describe 'roles.create' do
    before do
      login_as(super_user, :scope => :super_user)
      visit new_super_user_role_path

      fill_in 'role[description]', with: 'Описание новой роли'
    end

    context 'with valid attributes' do
      before { fill_in 'role[title]', with: role_title }

      it "adds a new record and redirects user" do
        expect{ click_on 'Создать' }.to change(Role, :count).by(1)
        expect(current_path).to eq super_user_roles_path

        expect(page).to have_content role_title
      end
    end

    context 'without valid attributes' do
      before { fill_in 'role[title]', with: invalid_attribute }

      it "doesn't add a new record and doesn't redirect user" do
        expect { click_on 'Создать' }.to_not change(Role, :count)
        expect(page).to have_content 'не может быть пустым'
      end
    end
  end

  describe 'roles.edit' do

    before do
      permission
      login_as(super_user, :scope => :super_user)
      visit edit_super_user_role_path(role)

      fill_in 'role[description]', with: 'Такой сякой товарищ'
    end

    context 'with valid attributes' do
      it 'redirects user and updates the record' do
        expect { click_on 'Сохранить' }.to_not change(Role, :count)
        expect(current_path).to eq super_user_roles_path

        role.reload
        expect(role.description).to_not eq old_role_description
      end
    end

    context 'without valid attributes' do
      it "doesn't update the record" do

        fill_in 'role[description]', with: invalid_attribute
        expect { click_on 'Сохранить' }.to_not change(Role, :count)

        role.reload
        expect(role.description).to_not eq invalid_attribute
      end
    end

    describe 'working with role permission additions', js: true do
      it "adds a new role permission" do
        click_on 'Добавить право'

        expect(page).to have_content "Удалить"
      end

      it 'deletes a role permission' do
        click_on 'Удалить'

        expect(page).not_to have_content "Удалить"
      end

      it 'saves a role with a permission' do
        click_on 'Добавить право'

        find('.role_role_permissions_permission select').all('option').last.select_option
        find('.role_role_permissions_result select').all('option').last.select_option

        expect { click_on 'Сохранить' }.to change(RolePermission, :count)
        expect(current_path).to eq super_user_roles_path
      end

      it "doesn't save duplicate roles" do
        click_on 'Добавить право'
        click_on 'Добавить право'

        first('.role_role_permissions_permission select').all('option').last.select_option
        first('.role_role_permissions_result select').all('option').last.select_option

        all('.role_role_permissions_permission select').last.all('option').last.select_option
        all('.role_role_permissions_result select').last.all('option').last.select_option

        click_on 'Сохранить'

        expect(RolePermission.count).to eq 1
        expect(current_path).to eq super_user_roles_path
      end
    end
  end

end

