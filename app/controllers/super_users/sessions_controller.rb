class SuperUsers::SessionsController < Devise::SessionsController
  layout 'super_users/sessions'
  
  after_action :super_user_logged_in, only: :create
  before_action :super_user_logged_out, only: :destroy

  def after_sign_in_path_for(resource)
    super_user_root_path
  end
  
  def super_user_logged_in
    Log.create(scope: 'auth_logs', user_id: resource.uuid, event_type: 'super_user_logged_in', result: 'Success')
  end
  
  def super_user_logged_out
    Log.create(scope: 'auth_logs', user_id: current_super_user.uuid, event_type: 'super_user_logged_out', result: 'Success')
  end

end