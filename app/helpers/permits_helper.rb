# Helper for permits rendering
# @note is used in permits form
module PermitsHelper
  # Returns formatted starts at date
  # @param permit [Permit]
  def h_permit_starts_at(permit)
    permit.new_record? ? Date.today.strftime("%d.%m.%Y") : permit.starts_at.strftime("%d.%m.%Y")
  end


  # Returns formatted expires at date
  # @param permit [Permit]
  def h_permit_expires_at(permit)
    permit.expires_at.strftime("%d.%m.%Y") if permit.persisted?
  end
end
