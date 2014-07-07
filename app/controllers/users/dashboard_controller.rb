class Users::DashboardController < BaseController
  before_action :authenticate_user!

  layout 'users/admin'

  def index
  end


end