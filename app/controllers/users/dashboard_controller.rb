class Users::DashboardController < Users::BaseController
  before_action :authenticate_user!

  layout 'users/admin'

  def index
  end

end