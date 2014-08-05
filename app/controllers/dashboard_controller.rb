class DashboardController < BaseController
  before_action :authenticate_user!

  def index
    @messages_count = 15
  end

  def global_state_dashboard
    permission_title = 'supervisor'

    # тут по идее нужно через can? работать.
    # это уже работа бэкенд специалистов
    @permission ||= Permission.where(title: permission_title).first

    unless @permission && current_user.permissions.include?(@permission)
      redirect_to users_root_path
    end
  end



end