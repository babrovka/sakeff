Normalizr.configure do
  default :strip, :blank
  
  add :cell_phone do |value|
    value.instance_of?(String) ? value.gsub(/[^0-9]+/, '').to_s[0..10] : value
  end
end