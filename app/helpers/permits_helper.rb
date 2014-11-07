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
  # @note is used in permits form
  # @param permit [Permit]
  def h_permit_expires_at(permit)
    end_day_of_year = DateFormatter.new Date.new(Date.today.year, 12, 31), :full
    persisted_date = DateFormatter.new permit.expires_at, :full
    permit.new_record? ? end_day_of_year : persisted_date
  end


  # Returns permit region
  # @note is used in permits form
  # @param permit [Permit]
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


  def h_permit_selected_region(permit)
    permit.region || 178
  end


  # Returns permit first car number first letter
  # @note is used in permits form
  # @param permit [Permit]
  def h_permit_selected_first_letter(permit)
    permit.car_number[0] if permit.car_number
  end


  # Returns permit car number numbers
  # @note is used in permits form
  # @param permit [Permit]
  def h_permit_selected_car_numbers(permit)
    permit.car_number[1..3] if permit.car_number
  end


  # Returns permit first car number second letter
  # @note is used in permits form
  # @param permit [Permit]
  def h_permit_selected_second_letter(permit)
    permit.car_number[4] if permit.car_number
  end


  # Returns permit first car number third letter
  # @note is used in permits form
  # @param permit [Permit]
  def h_permit_selected_third_letter(permit)
    permit.car_number[5] if permit.car_number
  end


  # Stores letters for car permit letters
  # @note is used in permits form
  def h_permit_car_letters
    %w[A B E K M H O P C T Y X]
  end


  # Stores letters for car permit regions
  # @note is used in permits form
  def h_permit_car_regions
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
     21, 22, 23, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
     38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 50, 51, 52, 53, 54,
     55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72,
     73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
     90, 91, 93, 93, 94, 95, 96, 96, 97, 98, 99, 102, 116, 118, 121, 125, 138,
     150, 150, 152, 154, 159, 161, 163, 164, 173, 174, 177, 178, 197, 199]
  end


  # Stores car brand names
  # @note is used in permits form
  def h_permit_car_brands
    ["AC", "Acura", "Alfa Romeo", "Aro", "Asia", "Aston Martin", "Audi", "Austin", "Bentley", "BMW", "BMW Alpina", "Brilliance",
     "Bugatti", "Buick", "BYD", "Cadillac", "Caterham", "ChangFeng", "Chery", "Chevrolet", "Chrysler", "Citroen", "Dacia", "Dadi",
     "Daewoo", "Daihatsu", "Daimler", "De Lorean", "Derways", "Dodge", "DongFeng", "Doninvest", "Eagle", "Ecomotors",
     "FAW", "Ferrari",
     "Fiat", "Fisker", "Ford", "Foton", "FSO", "Geely", "GMC", "Great Wall", "Hafei", "Haima", "Honda", "Hummer",
     "Hyundai", "Infiniti",
     "Iran Khodro", "Isuzu", "JAC", "Jaguar", "Jeep", "Kia", "Koenigsegg", "Lamborghini", "Lancia", "Land Rover",
     "Landwind", "Lexus", "Lifan",
     "Lincoln", "Lotus", "Luxgen", "Mahindra", "Maserati", "Maybach", "Mazda", "Mc Laren", "Mercedes-Benz", "Mercury",
     "Metrocab", "MG", "Mini",
     "Mitsubishi", "Mitsuoka", "Morgan", "Nissan", "Oldsmobile", "Opel", "Peugeot", "Plymouth", "Pontiac", "Porsche",
     "Proton", "PUCH", "Renault",
     "Rolls-Royce", "Rover", "Saab", "Saturn", "Scion", "SEAT", "ShuangHuan", "Skoda", "SMA", "Smart", "Spyker",
     "Ssang Yong", "Subaru", "Suzuki",
     "TATA", "Tatra", "Tesla", "Tianma", "Tianye", "Toyota", "Trabant", "Vauxhall", "Volkswagen", "Volvo", "Vortex",
     "Wartburg", "Westfield", "Wiesmann",
     "Xin Kai", "ZX", "Астро", "Бронто", "ВАЗ", "ГАЗ", "ЗАЗ", "ЗИЛ", "ИЖ", "КамАЗ", "ЛУАЗ", "Москвич (АЗЛК)",
     "СеАЗ", "СМЗ", "ТагАЗ", "УАЗ", "ВАЗ", "ЗАЗ",
     "СЕМАР", "ВИС", "ИЖ", "ТАГАЗ", "ГАЗ", "МОСКВИЧ (АЗЛК)", "УАЗ", "ЕРАЗ", "BARKAS", "FOTON", "MITSUBISHI",
     "BAW", "GMC", "MULTICAR", "BEDFORD", "GREAT WALL",
     "NISSAN", "BREMACH", "GROZ", "NYSA", "CHANGAN", "HONDA", "OPEL", "CHEVROLET", "HYUNDAI", "PEUGEOT", "CITROEN",
     "ISUZU", "RENAULT", "DACIA", "IVECO",
     "SKODA", "DAF", "JAC", "SSANG YONG", "DAIHATSU", "JINBEI", "SUBARU", "DODGE", "JMC", "TATA3", "DONGFENG",
     "KIA", "TOYOTA", "FAW", "LDV", "VOLKSWAGEN",
     "FIAT", "MAZDA", "YUEJIN", "FORD", "MERCEDES-BENZ", "Белорус", "Ромашка", "Ивановец", "JCB", "Лиаз", "Икарус"]
  end
end
