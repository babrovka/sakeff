require 'acceptance_helper'

feature "SuperUser manage User", %q() do

  let!(:super_user) { create(:super_user) }
  let!(:user) { create(:user) }
  let(:path) { super_user_root_path }

  background do
    login_as(super_user, :scope => :super_user)
    visit edit_super_user_user_path(user)

    #fill_in 'organization[inn]', with: '0987654321'
  end

  describe 'Edit user' do
    context 'with valid attributes' do
      scenario 'success update' do
        expect { click_on 'Сохранить' }.to_not change(Organization, :count)
        expect(current_path).to eq super_user_organizations_path

        # проверяем,что параметр изменился в БД
        organization.reload
        expect(organization.inn).to_not eq old_organization_inn
      end
    end

    context 'without valid attributes' do
      scenario 'failed update' do
        # по сценарию, ИНН имеет только 10 цифр,он и будет выступать в роли не верного параметра
        new_inn = '123456'

        fill_in 'organization[inn]', with: new_inn
        expect { click_on 'Сохранить' }.to_not change(Organization, :count)

        # проверяем,что параметр не записался в БД
        organization.reload
        expect(organization.inn).to_not eq new_inn
      end
    end
  end
end

