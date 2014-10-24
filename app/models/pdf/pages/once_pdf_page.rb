# Contains info about one time permit pdf page
# @note is used in OncePdfDocument
class Pdf::Pages::OncePdfPage < Pdf::Pages::BasePdfPage
  # Stores page background
  # @note is used in change_background of BasePdfRenderer
  def background
    "#{Rails.root}/app/assets/images/pdf_backgrounds/once.png"
  end


  # Stores page settings such as size, margin, etc
  # @note is used in draw_page of BasePdfRenderer
  def settings
    {
      margin: 20,
      size: "A4",
      layout: :landscape
    }
  end


  # Stores page text data
  # @note is used in draw_texts of BasePdfRenderer
  def data
    [
      {
        text: permit.id,
        coordinates: [295, 461],
        styles: { style: :bold, size: 16 }
      },
      {
        text: permit.id,
        coordinates: [675, 461],
        styles: { style: :bold, size: 16 }
      },

      {
        text: permit.last_name,
        coordinates: [80, 401]
      },
      {
        text: permit.last_name,
        coordinates: [495, 401]
      },

      {
        text: permit.first_name,
        coordinates: [43, 376]
      },
      {
        text: permit.first_name,
        coordinates: [458, 376]
      },

      {
        text: permit.middle_name,
        coordinates: [80, 350]
      },
      {
        text: permit.middle_name,
        coordinates: [495, 350]
      },

      {
        text: permit.doc_type_i18n,
        coordinates: [197, 323]
      },
      {
        text: permit.doc_type_i18n,
        coordinates: [612, 323]
      },

      {
        text: permit.doc_number,
        coordinates: [138, 297]
      },
      {
        text: permit.doc_number,
        coordinates: [553, 297]
      },

      {
        text: "#{permit.car_brand} #{permit.car_number}#{permit.region}",
        coordinates: [14, 244]
      },
      {
        text: "#{permit.car_brand} #{permit.car_number}#{permit.region}",
        coordinates: [427, 244]
      },

      {
        text: permit.location,
        coordinates: [52, 193]
      },
      {
        text: permit.location,
        coordinates: [467, 193]
      },

      {
        text: permit.person,
        coordinates: [63, 168]
      },
      {
        text: permit.person,
        coordinates: [478, 168]
      },

      {
        text: DateTime.now.day,
        coordinates: [32, 115]
      },
      {
        text: DateTime.now.day,
        coordinates: [447, 115]
      },

      {
        text: DateTime.now.month,
        coordinates: [82, 115]
      },
      {
        text: DateTime.now.month,
        coordinates: [497, 115]
      },

      {
        text: DateTime.now.year.to_s.last,
        coordinates: [192, 115]
      },
      {
        text: DateTime.now.year.to_s.last,
        coordinates: [607, 115]
      },
    ]
  end
end
