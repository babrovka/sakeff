# Stores one time permit pdf document data for Prawn
class Pdf::Documents::OneTimePdfDocument < Pdf::Documents::Base
  include ActsAsInterface

  # @see PdfDocument
  def fonts
    {
      'OpenSans' => {
        normal: "#{Rails.root}/app/assets/fonts/OpenSans_Regular/OpenSans-Regular-webfont.ttf",
        bold: "#{Rails.root}/app/assets/fonts/OpenSans_Bold/OpenSans-Bold-webfont.ttf"
      }
    }
  end


  # @see PdfDocument
  def pages
    [:one_time_pdf_page]
  end
end
