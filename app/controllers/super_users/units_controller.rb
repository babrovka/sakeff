class SuperUsers::UnitsController < SuperUsers::BaseController
  include TreeHandler
  before_action :authenticate_super_user!

  layout 'super_users/admin'

  def index
    @units = Unit.all
  end

end