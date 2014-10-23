# Handles rendering of a transport permit
class TransportPDFRenderer < PDFRenderer
  # @see PDFRenderer
  def draw_document
    front_page = FrontTransportPDFPage.new(@permit)
    draw_page(front_page)

    back_page = BackTransportPDFPage.new(@permit)
    draw_page(back_page)
  end


  private


  # @see PDFRenderer
  def init_fonts
    font_families.update(
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
    )
  end
end
