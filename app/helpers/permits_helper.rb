# Helper for permits rendering
# @note is used in permits form
module PermitsHelper
  # Returns formatted starts at date
  # @param permit [Permit]
  def h_permit_starts_at(permit)
    today = DateFormatter.new Date.today, :full
    persisted_date = DateFormatter.new permit.starts_at, :full
    permit.new_record? ? today : persisted_date
  end


  # Returns formatted expires at date
  # @param permit [Permit]
  def h_permit_expires_at(permit)
    end_day_of_year = DateFormatter.new Date.new(Date.today.year, 12, 31), :full
    persisted_date = DateFormatter.new permit.expires_at, :full
    permit.new_record? ? end_day_of_year : persisted_date
  end
end
