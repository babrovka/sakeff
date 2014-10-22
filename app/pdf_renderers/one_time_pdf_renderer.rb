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


  # def draw_dashed_line
  #   stroke do
  #     dash(4)
  #     stroke_color "aaaaaa"
  #     line(bounds.bottom_right, bounds.top_right)
  #   end
  # end


  # def draw_text_with_line(label, content)
  #   label_width = width_of(label) / 2 + 10 # because shut up and russian symbols work this way
  #
  #   margin_top = 20
  #   margin_left = 20
  #   margin_right = 20
  #
  #   label_start_point = [margin_left, margin_top]
  #   content_start_point = [label_width + margin_left, margin_top]
  #   content_width = bounds.right - (label_width + margin_left + margin_right)
  #
  #   font 'OpenSansRegular' do
  #     text_box label, at: label_start_point, width: label_width + margin_right, inline_format: true
  #     text_box content, at: content_start_point, width: content_width, align: :center, inline_format: true
  #     # transparent(0.5) { stroke_bounds }
  #   end
  #
  #   margin_bottom = 6
  #   bottom_left = [
  #     label_width + margin_right,
  #     bounds.bottom_left.last + margin_bottom
  #   ]
  #   bottom_right = [
  #     bounds.bottom_right.first - margin_right,
  #     bounds.bottom_right.last + margin_bottom
  #   ]
  #
  #   stroke do
  #     dash(0)
  #     line_width 1
  #     stroke_color "bbbbbb"
  #     line(bottom_left, bottom_right)
  #   end
  # end


  # todo: make array of lines
  # def draw_left_page
  #   grid([0, 0], [19, 0]).bounding_box do
  #     draw_dashed_line
  #
  #     font 'OpenSansRegular' do
  #       text "Обособленное подразделение «Управление по эксплуатации КЗС» ОАО Метрострой»"
  #     end
  #
  #     grid([1, 0], [1, 0]).bounding_box do
  #       draw_text_with_line("<color rgb='00ff00'><font-size='18'>Корешок разового пропуска №</font></color>", "666888")
  #     end
  #     #todo: add different method for help
  #     grid([2, 0], [2, 0]).bounding_box do
  #       draw_text_with_line("Фамилия", "Иванов")
  #     end
  #     grid([3, 0], [3, 0]).bounding_box do
  #       draw_text_with_line("Имя", "Иван")
  #     end
  #     grid([4, 0], [4, 0]).bounding_box do
  #       draw_text_with_line("Отчество", "Иванович")
  #     end
  #     grid([5, 0], [5, 0]).bounding_box do
  #       draw_text_with_line("Наименование документа", "Паспорт")
  #     end
  #     grid([6, 0], [6, 0]).bounding_box do
  #       draw_text_with_line("Его серия и номер", "4056 123434")
  #     end
  #     #todo: add new line option
  #     grid([7, 0], [8, 0]).bounding_box do
  #       draw_text_with_line("Гос. номер и марка автотранспортного средства", "Руцке35 ВАпрвапрр Losdfg")
  #     end
  #     grid([9, 0], [9, 0]).bounding_box do
  #       draw_text_with_line("Следует", "Туда")
  #     end
  #     grid([9, 0], [9, 0]).bounding_box do
  #       draw_text_with_line("Куда", "Америка")
  #     end
  #     grid([10, 0], [10, 0]).bounding_box do
  #       draw_text_with_line("К кому", "К Васе")
  #     end
  #     grid([11, 0], [11, 0]).bounding_box do
  #       draw_text_with_line("Выдан", "Вовой")
  #     end
  #     #todo: add different method for data
  #     grid([12, 0], [12, 0]).bounding_box do
  #       draw_text_with_line("Дежурный охранник КПП", "Иванович")
  #     end
  #     #todo: add different method for signature
  #   end
  #
  # end


  # Enables fonts
  # @note is called in draw_document
  # @todo: make correct assets path
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
