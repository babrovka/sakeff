# Contains methods for units views rendering for super users
class SuperUsers::UnitsController < SuperUsers::BaseController
  before_action :authenticate_super_user!

  layout 'super_users/admin'


  def upload
  end

  def import
    xls_file = Uploader.create!(file: params[:file])
    Importers::UnitImporter.delay.import xls_file.file.path
    redirect_to super_user_units_path
  end

end