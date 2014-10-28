module Documents::ResourceSortableHelper
  # кнопка сортировка в виде текста с иконкой
  def resource_sortable(column, title = nil)
    icon_class = resource_sortable_icon_class(column)
    resource_sortable_wrapper column do
      content_tag(:span, title)+
      content_tag(:span, nil, class: "fa #{icon_class}")
    end.html_safe
  end

  # кнопка сортировка только в виде иконки
  def resource_sortable_icon(column, opts={})
    order_class = resource_sortable_icon_class(column) + ' js-tooltip'
    resource_sortable_wrapper column, opts do
      content_tag(:span, nil, class: order_class, title: resource_sortable_hint_title(column))
    end.html_safe
  end

  def render_attr resource, attr
    value=resource.public_send(attr)
    value.blank? ? I18n.t('attributes.empty') : value
  end


  private

  # обертка под кнопку сортировки
  # представляет из себя ссылку,внутрь которой помещается кода — текст и иконки для кнопки
  def resource_sortable_wrapper(column, opts = {}, &block)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_class = "link link-success link-nounderline #{opts.delete(:class)}"
    link_to params.merge(sort: column, direction: direction, page: nil), { class: link_class } do
      yield
    end.html_safe
  end

  # иконка сортировки,стрелка вверх-вниз в зависимости от ASC DESC текущей сортировки
  def resource_sortable_icon_class(column)
    column == sort_column ? "fa fa-sort-#{sort_direction}" : 'fa fa-sort'
  end

  # формируем подсказку для кнопки сортировки
  def resource_sortable_hint_title(column)
    txt = ['Сортировать']
    txt << if column == sort_column
            if sort_direction == 'asc'
              'Я → А'
            elsif sort_direction == 'desc'
              'А → Я'
            end
          end
    txt.join(' ')
  end
end
