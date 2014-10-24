# Stores human permit pdf document data for Prawn
class Pdf::Documents::HumanPdfDocument < Pdf::Documents::Base
  include ActsAsInterface

  # @see PdfDocument
  def fonts
    {
      'OpenSans' => {
        normal: "#{Rails.root}/app/assets/fonts/OpenSans_Regular/OpenSans-Regular-webfont.ttf"
      }
    }
  end


  # @see PdfDocument
  def pages
    [:human_pdf_page]
  end
end
