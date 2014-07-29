class SuperUsers::SessionsController < Devise::SessionsController
  layout 'super_users/sessions'
  
  after_action :super_user_logged_in, only: :create
  after_action :log_failed_login, :only => [:new, :create]
  
  def destroy
    super_user_uuid = current_super_user.uuid
    super
    Log.create(scope: 'auth_logs', user_id: super_user_uuid, event_type: 'super_user_logged_out', result: 'Success')
  end

  def after_sign_in_path_for(resource)
    super_user_root_path
  end
  
  def super_user_logged_in
    Log.create(scope: 'auth_logs', user_id: current_super_user.uuid, event_type: 'super_user_logged_in', result: 'Success')
  end

  def log_failed_login
    if failed_login?
      email = params[:super_user][:email]
      if SuperUser.exists?(email: email)
        super_user = SuperUser.find_by_email(email)
        Log.create!(scope: 'auth_logs', user_id: super_user.uuid, event_type: 'super_user_logged_in', result: 'Error')
      end
    end
  end

  def failed_login?
    (options = env["warden.options"]) && options[:action] == "unauthenticated"
  end

end