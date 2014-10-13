# coding:utf-8
module Documents
  module TableFiltersHelper
    def table_filter_form
    end

    # TODO-justvitalius: а что если target сделать зависимым от search_field
    # метод для отрисовки лэйбла-кнопки в шапке таблицы, которая активирует какой-то элемент фильтровой формы
    # title — название лэйбла-кнопки
    # object — объект класса ransack, вокруг которого и строится фильтр
    # search_field — название поискового поля, к которому привязывается кнопка
    # target
    def table_filter_caption(title, object, search_field, target)
      classes = ['label label-sm js-table-filter-activate-btn']

      # преобразуем атрибут к массиву
      search_field = [search_field] unless search_field.class == Array
      search_field.each do |_search_field|
        classes << 'label-gray-d m-label-active js-table-filter-filled-form' unless object.try(_search_field.to_sym).blank?
      end.compact

      content_tag :div, class: classes, data: { target: target } do
        content_tag(:span, title) +
        content_tag(:span, nil, class: 'fa fa-filter')
      end.html_safe
    end




    # ячейка таблицы с кусочком фильтровой формы и chosen
    def table_filter_chosen(resource, caption, search_field, collection, target)
      table_filter_wrapper resource, caption, target do |f|
        f.select search_field, collection, {}, class: 'js-chosen', multiple: true
      end
    end

    # ячейка таблицы с кусочком фильтровой формы и текстового поля
    def table_filter_text(resource, caption, search_field, target)
      table_filter_wrapper resource, caption, target do |f|
        f.text_field search_field, class: 'form-control', autocomplete: :off
      end
    end


    private

    # обертка для ячейки таблицы. Внутрь помещаем элемент формы, параметры которого и отправляются на сервер
    def table_filter_wrapper(resource, caption, target, &block)
      content_tag :th, class: 'js-table-filter-form form-horizontal', data: { target: target }, colspan: 8 do
        search_form_for resource, url: documents_documents_path, html: { class: 'form-horizontal', data: { url: search_documents_documents_path }, multiple: true } do |f|
          content_tag(:h3, t(caption, scope: 'documents.filter.headers')) +
          content_tag(:div, class: 'form-group') do
            content_tag(:div, class: 'col-sm-6') do
              # судя по документации к form_for
              # https://github.com/rails/rails/blob/7a085dac2a2820856cbe6c2ca8c69779ac766a97/actionview/lib/action_view/helpers/form_helper.rb#L413
              # метод capture() нужно использовать,чтобы работать с блоком кода извне и передавать по цепочке вниз
              # к примеру:
              #     my_custom_method do |builder|
              #       builder.form_input_tag()
              capture(f, &block)
            end
          end.html_safe +
          table_filter_buttons(f)
        end
      end
    end


    # кнопки в фильтровой форме
    def table_filter_buttons(f)
      content_tag :div, class: 'btn-block b-offset-sm' do
        f.submit('Сохранить', class: 'btn btn-primary') +
        content_tag(:span, 'или') +
        link_to('сбросить', '#', class: 'link link-danger js-document-filter-clear-btn')
      end
    end

  end
end