class Users::DashboardController < BaseController
  include UnderConstruction

  before_action :authenticate_user!
  #protect_from_forgery
  layout 'users/admin'

  before_filter only: [:index] do self.redirect_to_under_construction("Личный кабинет") end

end