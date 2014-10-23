# Handles rendering of a one time permit
class OneTimePDFRenderer < PDFRendererInterface
  # @see PDFRenderer
  def draw_document
    draw_texts(left_page_texts)
    draw_texts(right_page_texts)
  end


  private


  # @see PDFRenderer
  def permit_data
    @permit_data ||= {
      id: @permit.id,
      last_name: @permit.last_name,
      first_name: @permit.first_name,
      middle_name: @permit.middle_name,
      doc_type: @permit.doc_type_i18n,
      doc_number: @permit.doc_number,
      auto: "#{@permit.car_brand} #{@permit.car_number}#{@permit.region}",
      location: @permit.location,
      person: @permit.person,
      day: DateTime.now.day,
      month: DateTime.now.month,
      year: DateTime.now.year.to_s.last
    }
  end


  # Contains texts for left page
  # @note is used in draw_document and is needed for draw_texts
  def left_page_texts
    @left_page_texts ||= [
      [:id, 295, { style: :bold, size: 16 }],
      [:last_name, 80],
      [:first_name, 43],
      [:middle_name, 80],
      [:doc_type, 197],
      [:doc_number, 138],
      [:auto, 14],
      [:location, 52],
      [:person, 63],
      [:day, 32],
      [:month, 82],
      [:year, 192]
    ]
  end


  # Contains texts for right page
  # @note is used in draw_document and is needed for draw_texts
  def right_page_texts
    @right_page_texts ||= [
      [:id, 675, { style: :bold, size: 16 }],
      [:last_name, 495],
      [:first_name, 458],
      [:middle_name, 495],
      [:doc_type, 612],
      [:doc_number, 553],
      [:auto, 427],
      [:location, 467],
      [:person, 478],
      [:day, 447],
      [:month, 497],
      [:year, 607]
    ]
  end


  # @see PDFRenderer
  def y_coordinates
    @y_coordinates ||= {
      id: 461,
      last_name: 401,
      first_name: 376,
      middle_name: 350,
      doc_type: 323,
      doc_number: 297,
      auto: 244,
      location: 193,
      person: 168,
      day: 115,
      month: 115,
      year: 115
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
      page_size: "A4",
      page_layout: :landscape,
      background: "#{Rails.root}/app/assets/images/pdf_templates/one_time.jpg"
    }
  end
end
