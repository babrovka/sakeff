class SuperUsers::BaseController < ApplicationController
  layout 'super_users/admin'
  before_action :authenticate_super_user!
end
