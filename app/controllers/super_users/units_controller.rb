# Contains methods for units views rendering for super users
class SuperUsers::UnitsController < SuperUsers::BaseController
  before_action :authenticate_super_user!

  layout 'super_users/admin'


  def upload
  end

  def import
    file = Uploader.create!(file: params[:file])
    u=UnitLoader.new
    u.delay.load_units(file.file.path)
    redirect_to :back
  end

end