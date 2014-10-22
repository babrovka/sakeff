# Handles rendering of a one time permit renderer
class OneTimePDFRenderer < PDFRenderer
  # @see PDFRenderer
  def draw_document
    init_fonts
    draw_left_page
    draw_right_page
  end


  private


  # Holds shared info for y coordinates
  # @note is used in draw_text and must be manually maintained
  def y_coordinates
    @y_coordinates ||= {
      number: 458,
      surname: 401,
      name: 376,
      second_name: 350,
      doc_name: 323,
      doc_number: 297,
      auto: 244,
      follows: 220,
      where: 193,
      to_who: 168,
      given: 142,
      day: 115,
      month: 115,
      year: 115,
      guardian: 89,
      escape_hours: 89,
      escape_minutes: 89,
      acceptor: 56
    }
  end


  # temp method will be changed to a real permit
  def permit
    @permit ||= {
      number: "02345234523",
      surname: "Иванов",
      name: "Иван",
      second_name: "Иванович",
      doc_name: "Паспорт",
      doc_number: "4056 2342343",
      auto: "Mercedes Benz Mega lol Р123РК78",
      follows: "Ничего не понятно в общем",
      where: "На дамбу",
      to_who: "К Уасе",
      given: "Уовой",
      day: "30",
      month: "июня",
      year: "92",
      guardian: "Василий",
      escape_hours: "18",
      escape_minutes: "02",
      acceptor: "Тов. Пищовский"
    }
  end


  # Draws left page of one time pdf
  # @note is called in draw_document
  def draw_left_page
    draw_text(:number, :bold, 295)
    draw_text(:surname, :normal, 80)
    draw_text(:name, :normal, 43)
    draw_text(:second_name, :normal, 80)
    draw_text(:doc_name, :normal, 197)
    draw_text(:doc_number, :normal, 138)
    draw_text(:auto, :normal, 14)
    draw_text(:follows, :normal, 73)
    draw_text(:where, :normal, 52)
    draw_text(:to_who, :normal, 63)
    draw_text(:given, :normal, 63)
    draw_text(:day, :normal, 32)
    draw_text(:month, :normal, 82)
    draw_text(:year, :normal, 192)
    draw_text(:guardian, :normal, 185)
  end


  # Draws right page of one time pdf
  # @note is called in draw_document
  def draw_right_page
    draw_text(:number, :bold, 675)
    draw_text(:surname, :normal, 495)
    draw_text(:name, :normal, 458)
    draw_text(:second_name, :normal, 495)
    draw_text(:doc_name, :normal, 612)
    draw_text(:doc_number, :normal, 553)
    draw_text(:auto, :normal, 427)
    draw_text(:follows, :normal, 488)
    draw_text(:where, :normal, 467)
    draw_text(:to_who, :normal, 478)
    draw_text(:given, :normal, 478)
    draw_text(:day, :normal, 447)
    draw_text(:month, :normal, 497)
    draw_text(:year, :normal, 607)
    draw_text(:escape_hours, :normal, 478)
    draw_text(:escape_minutes, :normal, 563)
    draw_text(:acceptor, :normal, 427)
  end


  # Draws text at given location and style
  # @note takes y coordinates from y_coordinates
  # @param column_name [Symbol] column name of Permit model
  # @param style [Symbol] font style
  # @param x_location [Integer] x coordinates of this text
  def draw_text(column_name, style, x_location)
    text_coordinates = [x_location, y_coordinates[column_name]]
    text = permit[column_name]
    font 'OpenSans' do
      text_box text, at: text_coordinates, style: style
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
