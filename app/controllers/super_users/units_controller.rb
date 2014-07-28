class SuperUsers::UnitsController < SuperUsers::BaseController
  before_action :authenticate_super_user!

  layout 'super_users/admin'

  def index
    @lol = 123
  end

end