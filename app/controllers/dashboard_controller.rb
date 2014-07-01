class DashboardController < BaseController
  before_action :authenticate_user!, except: [:public]

  def private
  end

  def public
  end
end