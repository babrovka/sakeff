# Contains info about front transport pdf page
# @note is used in TransportPDFRenderer
class Pdf::Pages::FrontTransportPdfPage < Pdf::Pages::Base
  # @see Base
  def background
    "#{Rails.root}/app/assets/images/pdf_templates/transport_front.png"
  end


  # @see Base
  def settings
    {
      margin: 20,
      size: [595, 419]
    }
  end


  # @see Base
  def data
    [
      {
        text: DateTime.now.year,
        coordinates: [20, 360],
        styles: { style: :bold, font: "RoadRadio", size: 56, color: "ffffff" }
      },
      {
        text: "№ #{permit.id}",
        coordinates: [385, 265],
        styles: { font: "RoadRadio", size: 54, color: "ffffff" }
      },
      {
        text: permit.car_number,
        coordinates: [255, 90],
        styles: { font: "RoadNumbers", size: 64 }
      },
      {
        text: permit.region,
        coordinates: [465, 95],
        styles: { font: "RoadNumbers", size: 46 }
      }
    ]
  end
end
