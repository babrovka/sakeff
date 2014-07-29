# Contains methods for units views rendering for users
class Users::UnitsController < BaseController
  before_action :authenticate_user!

  layout 'users/admin'
end