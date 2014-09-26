module Features
  module RoutesHelper
    # Contains info about pages which should have screenshots.
    # Update it manually after creating new page
    # @note launch with
    #   $ zeus test -t screenshots spec
    # @note path: route path, access: guest/super_user/user as symbol,
    #       file_name: path to view file, including its name,
    #       action: proc or lambda which will execute before taking a screenshot
    # @example
    #   { path: super_user_organizations_path, access: :super_user,
    #     file_name: "super_users_organizations_index", action: -> { click_on "Создать" } }
    # @return [Array]
    def routes_array
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

       { path: messages_broadcast_path, access: :user, file_name: "im_messages_index" },

       { path: super_user_units_path, access: :super_user, file_name: "super_users_units_index" },
       { path: units_path, access: :user, file_name: "units_index", action:
         -> do
           all(".jstree-ocl").last.click
         end },

       { path: library_path, access: :guest, file_name: "library" }
      ]
    end
  end
end