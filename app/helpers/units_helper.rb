# Helper for units rendering
module UnitsHelper

  # Returns parent id of unit
  # @note is used in api
  # @param unit [Unit]
  # @return [Uuid]
  def h_unit_parent(unit)
    unit.parent.try(:id).try(:upcase) || '#'
  end


  # Indicates whether unit is faved by a user
  # @note is used in api
  # @param unit [Unit]
  # @return [Boolean]
  def h_unit_is_favourite?(unit)
    unit.is_favourite_of_user?(current_user) if user_signed_in?
  end

end
