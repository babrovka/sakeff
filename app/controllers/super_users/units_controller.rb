# Contains methods for units views rendering for super users
class SuperUsers::UnitsController < SuperUsers::BaseController
  before_action :authenticate_super_user!

  layout 'super_users/admin'
<<<<<<< HEAD
=======

  def index
    @lol = 123
  end

>>>>>>> Units controller and route for super users
end