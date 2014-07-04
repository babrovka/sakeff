class BaseController < ApplicationController
  before_action :authenticate_user!

  layout 'super_users/admin'
end