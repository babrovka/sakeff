class SuperUsers::SessionsController < Devise::SessionsController
  layout 'super_users/sessions'
  
  after_action :super_user_logged_in, only: :create

  def after_sign_in_path_for(resource)
    super_user_root_path
  end
  
  
  def super_user_logged_in
    Log.create(scope: 'auth_logs', user_id: resource.uuid, event_type: 'super_user_logged_in', result: 'Success')
  end

end