# Contains methods for units views rendering for super users
class SuperUsers::UnitsController < SuperUsers::BaseController
  before_action :authenticate_super_user!

  layout 'super_users/admin'


  def upload
  end

  def import
    u=UnitLoader.new
    u.load_units(params[:file].tempfile)
    redirect_to :back
  end

end