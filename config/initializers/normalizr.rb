Normalizr.configure do
  default :strip, :blank
  
  add :cell_phone do |value|
    if String === value
      value = value.gsub(/[^0-9]+/, '')
      value = value.to_s[0..10]
      value unless value.empty?
    else
      value
    end
  end
end