class Users::DashboardController < BaseController
  before_action :authenticate_user!
  #protect_from_forgery

  def index
    @user = User
  end


end