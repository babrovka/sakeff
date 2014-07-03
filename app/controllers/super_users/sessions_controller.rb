class SuperUsers::SessionsController < Devise::SessionsController
  layout 'super_users/sessions'

  def after_sign_in_path_for(resource)
    super_users_root_path
  end

end