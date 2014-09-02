class PagesController < ApplicationController

  layout 'public'

  def index
    redirect_to control_dashboard_path if user_signed_in?
  end


end