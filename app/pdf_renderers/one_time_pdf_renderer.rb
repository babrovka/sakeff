# Handles rendering of a one time permit renderer
class OneTimePDFRenderer < PDFRenderer
  # @see PDFRenderer
  def draw_document
    init_fonts

    define_grid(columns: 2, rows: 20, gutter: 2)
    # grid.show_all

    draw_left_page
    # draw_right_page
  end


  private


  def draw_dashed_line
    stroke do
      dash(4)
      stroke_color "aaaaaa"
      line(bounds.bottom_right, bounds.top_right)
    end
  end


  def draw_text_with_line(label, content)
    label_width = width_of(label) / 2 + 10 # because shut up and russian symbols work this way

    margin_top = 20
    margin_left = 20
    margin_right = 20

    label_start_point = [margin_left, margin_top]
    content_start_point = [label_width + margin_left, margin_top]
    content_width = bounds.right - (label_width + margin_left + margin_right)

    font 'OpenSansRegular' do
      text_box label, at: label_start_point, width: label_width + margin_right, inline_format: true
      text_box content, at: content_start_point, width: content_width, align: :center, inline_format: true
      # transparent(0.5) { stroke_bounds }
    end

    margin_bottom = 6
    bottom_left = [
      label_width + margin_right,
      bounds.bottom_left.last + margin_bottom
    ]
    bottom_right = [
      bounds.bottom_right.first - margin_right,
      bounds.bottom_right.last + margin_bottom
    ]

    stroke do
      dash(0)
      line_width 1
      stroke_color "bbbbbb"
      line(bottom_left, bottom_right)
    end
  end


  # todo: make array of lines
  def draw_left_page
    grid([0, 0], [19, 0]).bounding_box do
      draw_dashed_line

      font 'OpenSansRegular' do
        text "Обособленное подразделение «Управление по эксплуатации КЗС» ОАО Метрострой»"
      end

      grid([1, 0], [1, 0]).bounding_box do
        draw_text_with_line("<color rgb='00ff00'><font-size='18'>Корешок разового пропуска No</font></color>", "666888")
      end
      #todo: add different method for help
      grid([2, 0], [2, 0]).bounding_box do
        draw_text_with_line("Фамилия", "Иванов")
      end
      grid([3, 0], [3, 0]).bounding_box do
        draw_text_with_line("Имя", "Иван")
      end
      grid([4, 0], [4, 0]).bounding_box do
        draw_text_with_line("Отчество", "Иванович")
      end
      grid([5, 0], [5, 0]).bounding_box do
        draw_text_with_line("Наименование документа", "Паспорт")
      end
      grid([6, 0], [6, 0]).bounding_box do
        draw_text_with_line("Его серия и номер", "4056 123434")
      end
      #todo: add new line option
      grid([7, 0], [8, 0]).bounding_box do
        draw_text_with_line("Гос. номер и марка автотранспортного средства", "Руцке35 ВАпрвапрр Losdfg")
      end
      grid([9, 0], [9, 0]).bounding_box do
        draw_text_with_line("Следует", "Туда")
      end
      grid([9, 0], [9, 0]).bounding_box do
        draw_text_with_line("Куда", "Америка")
      end
      grid([10, 0], [10, 0]).bounding_box do
        draw_text_with_line("К кому", "К Васе")
      end
      grid([11, 0], [11, 0]).bounding_box do
        draw_text_with_line("Выдан", "Вовой")
      end
      #todo: add different method for data
      grid([12, 0], [12, 0]).bounding_box do
        draw_text_with_line("Дежурный охранник КПП", "Иванович")
      end
      #todo: add different method for signature
    end

  end


  def draw_right_page
    grid([0, 1], [19, 1]).bounding_box do
    end
  end



  # Enables fonts
  def init_fonts
    font_families.update(
      'OpenSansRegular' => {
        normal: "#{Rails.root}/app/assets/fonts/OpenSans_Regular/OpenSans-Regular-webfont.ttf"
      }
    )
  end


  # @see PDFRenderer
  def layout_settings
    {
      margin: 0,
      page_size: "A4",
      page_layout: :landscape
    }
  end
end
