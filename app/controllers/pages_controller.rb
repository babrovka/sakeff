class PagesController < ApplicationController

  layout 'public'

  def index
    redirect_to users_root_path if user_signed_in?
  end

end