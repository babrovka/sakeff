# Stores human permit pdf document data for Prawn
class Pdf::Documents::Human < Pdf::Documents::Base
  # Stores document fonts
  # @note is used in init_fonts in Base
  def fonts
    {
      'OpenSans' => {
        normal: "#{Rails.root}/app/assets/fonts/OpenSans_Regular/OpenSans-Regular-webfont.ttf"
      }
    }
  end


  # Stores pages which must be rendered
  # @note is used in draw_document in Base
  def pages
    [:human]
  end
end
