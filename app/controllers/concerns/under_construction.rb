# Handles under construction page
module UnderConstruction
  extend ActiveSupport::Concern

  # Redirects to under construction page
  # @param page_name [String] a name of page which is under construction
  # @example
  #   redirect_to_under_construction("Личный кабинет")
  def redirect_to_under_construction(page_name)
    flash[:success] = page_name
    redirect_to under_construction_path
  end

end