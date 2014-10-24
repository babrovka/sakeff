# Contains info about front transport pdf page
# @note is used in CarPdfDocument
class Pdf::Pages::FrontCarPdfPage < Pdf::Pages::BasePdfPage
  # Stores page background
  # @note is used in change_background of BasePdfRenderer
  def background
    "#{Rails.root}/app/assets/images/pdf_backgrounds/car_front.png"
  end


  # Stores page settings such as size, margin, etc
  # @note is used in draw_page of BasePdfRenderer
  def settings
    {
      margin: 20,
      size: [595, 419]
    }
  end


  # Stores page text data
  # @note is used in draw_texts of BasePdfRenderer
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
