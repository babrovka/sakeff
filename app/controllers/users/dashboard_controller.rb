class Users::DashboardController < BaseController
  include UnderConstruction

  before_action :authenticate_user!
  #protect_from_forgery
  layout 'users/admin'

  def index
    # redirect_to_under_construction("Личный кабинет")
  end

end