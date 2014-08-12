class Users::SessionsController < Devise::SessionsController
  layout 'users/sessions'
  
  after_action :user_logged_in, only: :create
  after_action :log_failed_login, :only => [:new, :create]
  
  def destroy
    user_uuid = current_user.uuid
    super
    Log.create(scope: 'auth_logs', user_id: user_uuid, event_type: 'user_logged_out', result: 'Success')
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || request.referer || root_path
  end
  
  
  def user_logged_in
    Log.create(scope: 'auth_logs', user_id: current_user.uuid, event_type: 'user_logged_in', result: 'Success')
  end

  def log_failed_login
    if failed_login?
      username = params[:user][:username]
      user_uuid = User.where(username: username).first.try(:uuid) || nil
      event_type = user_uuid.blank? ? 'user_unknown' : 'user_invalid_password'
      Log.create!(scope: 'auth_logs', user_id: user_uuid, event_type: event_type, result: 'Error')
    end
  end

  def failed_login?
    (options = env["warden.options"]) && options[:action] == "unauthenticated"
  end
end