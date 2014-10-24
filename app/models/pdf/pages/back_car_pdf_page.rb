# Contains info about front transport pdf page
# @note is used in CarPdfDocument
class Pdf::Pages::BackCarPdfPage < Pdf::Pages::BasePdfPage
  # Stores page background
  # @note is used in change_background of BasePdfRenderer
  def background
    "#{Rails.root}/app/assets/images/pdf_backgrounds/car_back.png"
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
        text: permit.last_name,
        coordinates: [82, 330]
      },
      {
        text: permit.first_name,
        coordinates: [44, 295]
      },
      {
        text: permit.middle_name,
        coordinates: [80, 257]
      },
      {
        text: permit.car_brand,
        coordinates: [180, 150]
      },
      {
        text: permit.car_number,
        coordinates: [120, 100],
        styles: { font: "RoadNumbers", size: 54 }
      },
      {
        text: permit.region,
        coordinates: [283, 100],
        styles: { font: "RoadNumbers", size: 36 }
      },
      {
        text: "#{permit.expires_at.day}.#{permit.expires_at.month}.#{permit.expires_at.year}",
        coordinates: [145, 45]
      },
    ]
  end
end
