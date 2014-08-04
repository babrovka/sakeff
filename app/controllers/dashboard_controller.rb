class DashboardController < BaseController
  before_action :authenticate_user!

  def index

    @username = current_user.username
    @messages_count = 15

  end

end