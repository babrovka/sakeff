# Handles rendering of a transport permit
class TransportPDFRenderer < PDFRendererInterface
  # @see PDFRenderer
  def draw_document
    first_page_background = "#{Rails.root}/app/assets/images/pdf_templates/transport.png"
    draw_page(first_page_data, first_page_settings, first_page_background)
  end


  private


  def first_page_data
    @first_page_data ||= [
      {
        text: DateTime.now.year,
        coordinates: [20, 360],
        styles: { style: :bold, font: "RoadRadio", size: 56, color: "ffffff" }
      },
      {
        text: "№ #{@permit.id}",
        coordinates: [385, 265],
        styles: { font: "RoadRadio", size: 54, color: "ffffff" }
      },
      {
        text: @permit.car_number,
        coordinates: [255, 90],
        styles: { font: "RoadNumbers", size: 64 }
      },
      {
        text: @permit.region,
        coordinates: [465, 95],
        styles: { font: "RoadNumbers", size: 46 }
      }
    ]
  end


  def first_page_settings
    @first_page_settings ||= {
      margin: 20,
      size: [595, 419]
    }
  end


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
