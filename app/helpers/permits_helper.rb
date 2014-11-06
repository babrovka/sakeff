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


  # Render permit state
  def permit_state(permit)
    label_class = %w{label}
    label_class << case permit.status.to_s
                   when 'expired' then 'label-red m-invert'
                   when 'request' then 'label-gray'
                   when 'approved' then 'label-blue'
                   when 'produced' then 'label-cyan'
                   when 'issued' then 'label-sea-green m-invert'
                   when 'cancelled' then 'label-yellow-d'
                   else 'label-asphalt'
                   end

    icon = permit.approved? ? content_tag(:span, nil, class: 'fa fa-check') : ''.html_safe

    content_tag :span, class: label_class.join(' ') do
      icon + content_tag(:span, t(permit.status, scope: 'enums.permit.status'))
    end.html_safe
  end
end
