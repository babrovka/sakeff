# Handles under construction page
module UnderConstruction
  extend ActiveSupport::Concern

  # Redirects to under construction page
  # @param page_name [String] a name of page which is under construction
  # @example
  #   before_filter only: [:index] do |c| c.redirect_to_under_construction("Личный кабинет") end
  def redirect_to_under_construction(page_name)
    redirect_to under_construction_path(page_name: page_name)
  end

end