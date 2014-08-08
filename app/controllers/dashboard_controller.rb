class DashboardController < BaseController
  before_action :authenticate_user!

  def index
    @messages_count = 15
  end
end