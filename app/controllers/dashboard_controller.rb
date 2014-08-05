class DashboardController < BaseController
  before_action :authenticate_user!

  def index
    @messages_count = 15
  end

  def global_state_dashboard
    permission_title = 'supervisor'

    @permission ||= Permission.where(title: permission_title).first
  end



end