require 'acceptance_helper'

feature "SuperUser see Roles list", %q() do


  let(:super_user) { create(:super_user) }
  let(:path) { super_user_roles_path }

  describe 'Roles table' do

    before do
      login_as(super_user, :scope => :super_user)
    end

    context 'without storage roles' do
      scenario 'render <empty text>' do
        visit path
        expect(Role.count).to eq 0
        expect(page).to have_content 'Нет сохраненных ролей.'
      end
    end

    context 'with storage roles' do
      let!(:roles) do
        5.times.map { create(:role_with_permissions) }
      end

      let(:permissions) do
        roles.map { |role| role.permissions }.flatten
      end

      before { visit path }


      scenario 'render role titles' do
        expect(Role.count).to_not eq 0
        roles.each do |role|
          expect(page).to have_content role.title
        end
      end

      scenario 'render role permissions' do
        permissions.each do |permission|
          expect(page).to have_content permission.title
        end
      end

    end

  end

end

