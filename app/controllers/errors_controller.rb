# Handles all error/placeholder pages
class ErrorsController < ApplicationController

  layout 'empty'

  # Shows under construction page
  # @note GET /under_construction
  # @param page_name [String] a name of page which is under construction
  def under_construction
    @back = request.referer || root_path
    @page_name = params[:page_name] || "Страница"
  end

end