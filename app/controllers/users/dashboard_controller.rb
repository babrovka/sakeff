class Users::DashboardController < BaseController
  before_action :authenticate_user!
  #protect_from_forgery
  layout 'users/admin'

end