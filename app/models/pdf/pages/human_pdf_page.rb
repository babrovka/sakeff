# Contains info about human pdf page
# @note is used in HumanPdfDocument
class Pdf::Pages::HumanPdfPage < Pdf::Pages::BasePdfPage
  # Stores page background
  # @note is used in change_background of BasePdfRenderer
  def background
    "#{Rails.root}/app/assets/images/pdf_backgrounds/human.png"
  end


  # Stores page settings such as size, margin, etc
  # @note is used in draw_page of BasePdfRenderer
  def settings
    {
      margin: 0,
      size: [244, 164]
    }
  end


  # Stores page text data
  # @note is used in draw_texts of BasePdfRenderer
  def data
    font_size = 8
    white_text = {size: font_size, color: "B2B2B1"}
    black_text = {size: font_size}
    [
      {
        text: "ОАО «Метрострой»",
        coordinates: [89, 160],
        styles: black_text
      },
      {
        text: "Пропуск N",
        coordinates: [89, 147],
        styles: black_text
      },
      {
        text: permit.id,
        coordinates: [130, 147],
        styles: black_text
      },
      {
        text: "Ф.",
        coordinates: [89, 130],
        styles: white_text
      },
      {
        text: permit.last_name,
        coordinates: [100, 130],
        styles: black_text
      },
      {
        text: "И.",
        coordinates: [89, 116],
        styles: white_text
      },
      {
        text: permit.first_name,
        coordinates: [100, 116],
        styles: black_text
      },
      {
        text: "О.",
        coordinates: [89, 101],
        styles: white_text
      },
      {
        text: permit.middle_name,
        coordinates: [100, 101],
        styles: black_text
      },
      {
        text: "Должность:",
        coordinates: [89, 87],
        styles: white_text
      },
      {
        text: "Организация:",
        coordinates: [89, 59],
        styles: white_text
      },
      {
        text: "Подпись:",
        coordinates: [5, 32],
        styles: black_text
      },
      {
        text: "Действителен до:",
        coordinates: [5, 14],
        styles: black_text
      }
    ]
  end
end
