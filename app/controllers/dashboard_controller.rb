class DashboardController < BaseController
  before_action :authenticate_user!
  before_action :check_view_permits

  def index
  end

private

  def check_view_permits
    unless current_user.has_permission? :view_desktop
      redirect_to root_path
    end
  end
  
end