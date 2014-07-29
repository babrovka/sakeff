class Users::SessionsController < Devise::SessionsController
  layout 'users/sessions'
  
  after_action :user_logged_in, only: :create
  after_action :log_failed_login, :only => [:new, :create]
  
  def destroy
    super_user_uuid = current_super_user.uuid
    super
    Log.create(scope: 'auth_logs', user_id: super_user_uuid, event_type: 'user_logged_out', result: 'Success')
  end

  def after_sign_in_path_for(resource)
    users_root_path
  end
  
  
  def user_logged_in
    Log.create(scope: 'auth_logs', user_id: resource.uuid, event_type: 'user_logged_in', result: 'Success')
  end

  def log_failed_login
    if failed_login?
      email = params[:user][:username]
      if User.exists?(username: username)
        user = User.find_by_username(username)
        Log.create!(scope: 'auth_logs', user_id: user.uuid, event_type: 'user_logged_in', result: 'Error')
      end
    end
  end

  def failed_login?
    (options = env["warden.options"]) && options[:action] == "unauthenticated"
  end
end