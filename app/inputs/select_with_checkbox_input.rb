# coding: utf-8
# рисуем контрол состоящий из чекбокса и инпута.
# чекбокс имеет два варианта отрисовки:
# — с лэйблом (справа от чекбокса)
# — без лейбла
#
# если значения в инпуте были выбраны и сохранены в БД, то ставим галку в чекбоксе и делаем активным инпут
# если значений в инпуте нет, то галку убираем и дизэйблим инпут
#
# ВНИМАНИЕ!
# для полноценной работы на фронтенде требуется js-скрипты
class SelectWithCheckboxInput < SimpleForm::Inputs::CollectionInput

  def input
    out = ''
    out <<  template.content_tag(:div, class: 'row') do
              checkbox_with_title + select
            end
    out.html_safe
  end

  protected

  def updated_html_options
    required_options = { data: { target: uniq_name } }
    required_options[:disabled] = :disabled if input_options_blank? # если в селекте не выбраны значения, то дизэйблим его
    input_html_classes.push('js-chosen') # добавляем, чтобы включить chosen
    input_html_options[:data].merge!(required_options[:data]) if input_html_options[:data].present? # иначе никак не слить data атрибуты,чтобы не потерять их из разных мест
    required_options.merge(input_html_options) # окончательно сливаем элементы первого уровня
  end

  # определяем, есть ли сохраненные значения в данном селекте
  def input_options_blank?
    @builder.object.try(attribute_name).blank?
  end

  def select
    label_method, value_method = detect_collection_methods
    template.content_tag(:div, class: "col-sm-#{12-check_box_col}") do
      @builder.collection_select(
          attribute_name, collection, value_method, label_method,
          input_options, updated_html_options
      )
    end
  end

  def checkbox
    checked = input_options_blank? ? false : true # если значения в селекте есть, то ставим галочку
    template.check_box_tag("is_#{attribute_name}".to_sym, nil, checked, class: 'js-active-input', data: { target: uniq_name  })
  end

  def checkbox_title(&block)
    template.label_tag("is_#{attribute_name}".to_sym, class: 'control-label')  do
      yield +
      template.content_tag(:span, checkbox_text, checkbox_options)
    end
  end

  # рисуем чекбокс
  # — с лэйблом
  # — без лейбла
  def checkbox_with_title
    template.content_tag(:div, class: "col-sm-#{check_box_col}") do
      template.content_tag(:div, class: 'checkbox') do
        if has_checkbox_text?
          checkbox_title do
            checkbox
          end
        else
          checkbox
        end
      end
    end
  end

  def checkbox_options
    { class: 'js-label-hint label-icon-hint', title: checkbox_hint} if has_checkbox_hint?
  end

  # длина колонок бутстрапа для чекбокса
  def check_box_col
    has_checkbox_text? ? 4 : 1
  end

  # уникальное имя для чекбокса, по нему происходит связь между чекбоксом и инпутом на фронтенде через js-скрипт
  def uniq_name
    @select_with_checkbox_input_uniq_time ||= "#{attribute_name}-#{(DateTime.now.to_f*10**5).to_i.to_s}"
  end

end