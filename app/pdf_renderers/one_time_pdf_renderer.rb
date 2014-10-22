# Handles rendering of a one time permit renderer
class OneTimePDFRenderer < PDFRenderer
  # @see PDFRenderer
  def draw_document
    init_fonts
    draw_left_page
    draw_right_page
  end


  private

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


  # Holds shared info for y coordinates
  # @note is used in draw_text and must be manually maintained
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
      year: 115,
    }
  end


  # Draws left page of one time pdf
  # @note is called in draw_document
  def draw_left_page
    draw_text(:id, 295, { style: :bold, size: 16 })
    draw_text(:last_name, 80)
    draw_text(:first_name, 43)
    draw_text(:middle_name, 80)
    draw_text(:doc_type, 197)
    draw_text(:doc_number, 138)
    draw_text(:auto, 14)
    draw_text(:location, 52)
    draw_text(:person, 63)
    draw_text(:day, 32)
    draw_text(:month, 82)
    draw_text(:year, 192)
  end


  # Draws right page of one time pdf
  # @note is called in draw_document
  def draw_right_page
    draw_text(:id, 675, { style: :bold, size: 16 })
    draw_text(:last_name, 495)
    draw_text(:first_name, 458)
    draw_text(:middle_name, 495)
    draw_text(:doc_type, 612)
    draw_text(:doc_number, 553)
    draw_text(:auto, 427)
    draw_text(:location, 467)
    draw_text(:person, 478)
    draw_text(:day, 447)
    draw_text(:month, 497)
    draw_text(:year, 607)
  end


  # Draws text at given location and style
  # @note takes y coordinates from y_coordinates
  # @param column_name [Symbol] column name of Permit model
  # @param x_location [Integer] x coordinates of this text
  # @param options [Hash] styling options
  def draw_text(column_name, x_location, options = {})
    text_coordinates = [x_location, y_coordinates[column_name]]
    text = permit_data[column_name].to_s
    styles = {
      style: :normal,
      size: 12
    }.merge(options)

    font 'OpenSans' do
      text_box text, at: text_coordinates, style: styles[:style], size: styles[:size]
    end
  end


  # Enables fonts
  # @note is called in draw_document
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
