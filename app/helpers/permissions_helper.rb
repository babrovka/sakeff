# Helpers for simple display whether user has certain roles or not
module PermissionsHelper
  # Checks if user is a dispatcher (has Control access)
  # @return [Boolean]
  def is_dispatcher?
    signed_in? && current_user.has_permission?('dispatcher')
  end
end


# gon.push
#   user_permissions: user_permission.map{ permission_name: current_user.has_permission(permission_name) }
#
#
# has_permission('manage_')
#
#
# class CurrentUser
#   ha_permission: (name) ->
#       gon.user_permissio.findWhere()
# end