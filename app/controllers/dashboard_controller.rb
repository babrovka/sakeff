class DashboardController < BaseController
  before_action :authenticate_user!

  def index
    @messages_count = 15

    @eve = Control::Eve.instance
  end
end