# Contains custom authentication methods
module CustomAuthentication
  extend ActiveSupport::Concern

  # Checks if a super user or a normal user is signed in
  # @note is called on api methods
  def authenticate_anybody!
    super_user_signed_in? ? true : authenticate_user!
  end

end