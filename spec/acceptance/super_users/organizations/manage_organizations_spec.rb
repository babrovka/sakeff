require 'acceptance_helper'

feature "SuperUser manage Organizations", %q() do


  let(:super_user) { create(:super_user) }

  describe 'Create new Organization' do

    background do
      login_as(super_user, :scope => :super_user)
      visit new_super_user_organization_path

      fill_in 'organization[full_title]', with: 'Новая организация'
      fill_in 'organization[short_title]', with: 'Описание новой организации'
      fill_in 'organization[inn]', with: '1234567890'
      select 'ИП', from: 'organization[legal_status]'
    end

    context 'with valid attributes' do
      scenario 'success save' do
        expect{ click_on 'Создать' }.to change(Organization, :count).by(1)
        expect(current_path).to eq super_user_organizations_path
      end
    end

    context 'without valid attributes' do
      scenario 'failed save' do
        fill_in 'organization[inn]', with: 'invalid_attr'
        expect { click_on 'Создать' }.to_not change(Organization, :count)
        expect(page).to have_content 'не является числом'
      end
    end

  end


  describe 'Edit exist Organization' do

    let!(:organization) { create(:organization) }
    let!(:old_organization_inn) { organization.inn }

    background do
      login_as(super_user, :scope => :super_user)
      visit edit_super_user_organization_path(organization)

      fill_in 'organization[inn]', with: '0987654321'
    end

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

