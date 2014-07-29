class SuperUsers::UnitsController < SuperUsers::BaseController
  before_action :authenticate_super_user!

  layout 'super_users/admin'
end