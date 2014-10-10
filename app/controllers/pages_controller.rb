class PagesController < ApplicationController

  layout 'users/sessions'

  def index
    redirect_to dashboard_path if user_signed_in?
  end


end