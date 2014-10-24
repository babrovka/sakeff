# Stores transport permit pdf document data for Prawn
class Pdf::Documents::TransportPdfDocument < Pdf::Documents::Base
  include ActsAsInterface

  # @see PdfDocument
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


  # @see PdfDocument
  def pages
    [:front_transport_pdf_page, :back_transport_pdf_page]
  end
end
