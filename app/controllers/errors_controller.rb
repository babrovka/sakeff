# Handles all error/placeholder pages
class ErrorsController < ApplicationController

  before_action :get_page_info

  layout 'public'

  # Shows under construction page
  # @note GET /under_construction
  def under_construction
  end

  # Shows error page
  # @note GET /error_500
  def error_500
  end

  private

  # @param page_name [String] a name of page which is under construction
  def get_page_info
    @back = request.referer || root_path
    @page_name = params[:page_name] || "Страница"
  end

end