# Handles rendering of a transport permit
class TransportPDFRenderer < PDFRendererInterface
  # @see PDFRenderer
  def draw_document
    draw_texts(texts)
  end


  private


  # @see PDFRenderer
  def permit_data
    @permit_data ||= {
      id: "No #{@permit.id}",
      car_number: @permit.car_number,
      region: @permit.region
    }
  end


  # Contains texts for left page
  # @note is used in draw_document and is needed for draw_texts
  def texts
    @texts ||= [
      [:id, 384, { style: :bold, size: 46, color: "ffffff" }],
      [:car_number, 240, { style: :bold, size: 54 }],
      [:region, 460, { style: :bold, size: 36 }]
    ]
  end


  # @see PDFRenderer
  def y_coordinates
    @y_coordinates ||= {
      id: 260,
      car_number: 100,
      region: 102
    }
  end


  # @see PDFRenderer
  def init_fonts
    font_families.update(
      'OpenSans' => {
        normal: "#{Rails.root}/app/assets/fonts/OpenSans_Regular/OpenSans-Regular-webfont.ttf",
        bold: "#{Rails.root}/app/assets/fonts/OpenSans_Bold/OpenSans-Bold-webfont.ttf"
      }
    )
  end


  # @see PDFRenderer
  # @todo get a better pdf copy
  def layout_settings
    {
      margin: 20,
      page_size: [595, 420],
      background: "#{Rails.root}/app/assets/images/pdf_templates/transport.jpg"
    }
  end
end
