class SuperUsers::BaseController < ApplicationController
  layout 'super_users/application'
  before_action :authenticate_super_user!
end
