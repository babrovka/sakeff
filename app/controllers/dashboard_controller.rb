class DashboardController < BaseController
  include UnderConstruction

  before_action :authenticate_user!
  #protect_from_forgery

  def index
    redirect_to_under_construction("Дашбоард")
  end

end