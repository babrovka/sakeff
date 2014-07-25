class DateFormatter
  def initialize(date, format=:full)
    @date = date || ''
    @format = format || :full
    @format.to_sym if @format.is_a?(String)
  end

  def to_s
    @date.present? ? I18n.l(@date, :format => @format) : ''
  end

end