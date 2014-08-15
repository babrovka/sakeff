# Helpers for simple display whether user has certain roles or not
module PermissionsHelper
  # Checks if user is a dispatcher (has Control access)
  # @return [Boolean]
  def is_dispatcher?
    signed_in? && current_user.has_permission?('dispatcher')
  end
end