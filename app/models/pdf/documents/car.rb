# Stores transport permit pdf document data for Prawn
class Pdf::Documents::Car < Pdf::Documents::Base
  # Stores document fonts
  # @note is used in init_fonts in Base
  def fonts
    {
      'OpenSans' => {
        normal: "#{Rails.root}/app/assets/fonts/OpenSans_Regular/OpenSans-Regular-webfont.ttf",
        bold: "#{Rails.root}/app/assets/fonts/OpenSans_Bold/OpenSans-Bold-webfont.ttf"
      },
      'RoadRadio' => {
        normal: "#{Rails.root}/app/assets/fonts/RoadRadio/normal/RoadRadio.ttf",
        bold: "#{Rails.root}/app/assets/fonts/RoadRadio/bold/RoadRadio-Bold.ttf"
      },
      'RoadNumbers' => {
        normal: "#{Rails.root}/app/assets/fonts/RoadNumbers/normal/RoadNumbers.ttf"
      }
    }
  end


  # Stores pages which must be rendered
  # @note is used in draw_document in Base
  def pages
    [:front_car, :back_car]
  end
end
