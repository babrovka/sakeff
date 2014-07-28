require 'acceptance_helper'

feature "All pages are created correctly", js: true, screenshots: true do

  let(:super_user) { create(:super_user) }
  let(:permission) { create(:permission) }
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }

  # Contains info about pages which should have screenshots.
  # Update it manually after creating new page
  # @note launch with
  # $ zeus test -t screenshots spec
  # @note path: route path, access: guest/super_user/user as symbol,
  #       file_name: path to view file, including its name,
  #       action: proc or lambda which will execute before taking a screenshot
  # @example
  #   { path: super_user_organizations_path, access: :super_user,
  #     file_name: "super_users_organizations_index", action: -> { click_on "Создать" } }

  let(:routes) do
    [
     { path: new_user_session_path, access: :guest, file_name: "users_sessions_new" },
     { path: root_path, access: :guest, file_name: "root" },
     { path: new_super_user_session_path, access: :guest, file_name: "super_users_sessions_new" },
     { path: users_root_path, access: :user, file_name: "users_dashboard_index" },

     { path: super_user_root_path, access: :super_user, file_name: "super_users_dashboard_index" },

     { path: super_user_organizations_path, access: :super_user, file_name: "super_users_organizations_index" },
     { path: new_super_user_organization_path, access: :super_user, file_name: "super_users_organization_new" },
     { path: edit_super_user_organization_path(organization), access: :super_user, file_name: "super_users_organization_edit" },

     { path: super_user_users_path, access: :super_user, file_name: "super_users_users_index" },
     { path: new_super_user_user_path, access: :super_user, file_name: "super_users_users_new" },
     { path: edit_super_user_user_path(user), access: :super_user, file_name: "super_users_users_edit" },

     { path: super_user_roles_path, access: :super_user, file_name: "super_users_roles_index" },

     { path: super_user_permissions_path, access: :super_user, file_name: "super_users_permissions_index" },

     { path: library_path, access: :super_user, file_name: "library" }
    ]
  end

  shared_examples :screenshottable do |access|
    it "successfully opens pages and creates screenshots" do
      routes.select{|hash| hash[:access] == access}.each do |route|
        visit route[:path]
        route[:action].call if route[:action]

        screenshot_name = "#{route[:file_name]}.jpeg"
        screenshot_path = "#{Rails.root.join("test_images", "screenshots")}/#{screenshot_name}"
        page.save_screenshot(screenshot_path, full: true)

        expect(File.exists? screenshot_path).to be
      end
    end
  end

  context 'on guest pages' do
    it_behaves_like :screenshottable, :guest
  end

  context 'on user pages' do
    before { login_as(user, scope: :user) }

    it_behaves_like :screenshottable, :user
  end

  context 'on super_user pages' do
    before do
      login_as(super_user, scope: :super_user)
    end

    it_behaves_like :screenshottable, :super_user
  end
end