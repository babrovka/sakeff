# Stores human permit pdf document data for Prawn
class Pdf::Documents::HumanPdfDocument < Pdf::Documents::BasePdfDocument
  # Stores document fonts
  # @note is used in init_fonts in BasePdfRenderer
  def fonts
    {
      'OpenSans' => {
        normal: "#{Rails.root}/app/assets/fonts/OpenSans_Regular/OpenSans-Regular-webfont.ttf"
      }
    }
  end


  # Stores pages which must be rendered
  # @note is used in draw_document in BasePdfRenderer
  def pages
    [:human_pdf_page]
  end
end
