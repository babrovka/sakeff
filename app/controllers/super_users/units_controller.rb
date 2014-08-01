# Contains methods for units views rendering for super users
class SuperUsers::UnitsController < SuperUsers::BaseController
  before_action :authenticate_super_user!

  layout 'super_users/admin'


  def upload
  end

  def import
    xls_file = Uploader.create!(file: params[:file])
    UnitLoader.new.delay.load_units(xls_file.file.path)
    # path = "/srv/webdata/sakedev.cyclonelabs.com/shared/system/uploaders/files/000/000/008/original/units.xls"
    # UnitLoader.new.delay.load_units(path)
    redirect_to super_user_units_path
  end

end