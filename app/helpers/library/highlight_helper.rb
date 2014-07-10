module Library
  module HighlightHelper


    # подсветка кода
    # автоматически определяем кол-во строк и рисуем номера, если строк более,чем одна
    # все скрытые html-символы для текста по ссылке http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals
    def highlight_code(code)
      content_tag(:div, class: 'highlight') do
        prepare_to_highlight code
      end
    end


    # блок для подстветки кода с табами по разным языкам
    # highlight_named_code slim: %Q{}, html: %Q{}, js: %Q{}
    def highlight_named_code(*args)
      opts = args.extract_options!

      # уникальное имя генерируем вне этого модуля и оно зависит от момента времени, в который происходит рендеринг
      # т.к.кнопку tab и контент для этого tab рисуется в разные моменты времени, то нужно закешировать уникальные имена
      # в том количестве,сколько этих табов
      opts_uniq_ids = opts.map{ item_uniq_id }

      out = []
      i = -1
      out << content_tag(:ul, class: 'nav nav-pills lib-control-tabs') do
        opts.map do |k,v|
          content_tag(:li) do
            i += 1
            uniq_name = "##{opts_uniq_ids[i]}-#{k}"
            link_to(k, uniq_name, 'data-toggle' => 'tab')
          end
        end.join.html_safe
      end
      i = -1
      out << content_tag(:div, class: 'tab-content') do
              opts.map do |k, v|
                i += 1
                uniq_name = "#{opts_uniq_ids[i]}-#{k}"
                content_tag(:div, class: 'tab-pane', id: uniq_name) do
                  prepare_to_highlight v
                end
              end.join.html_safe
            end

      content_tag :div, class: 'highlight' do
        out.join.html_safe
      end
    end


    private

    def prepare_to_highlight(code)
      lines = ' '
      # lines = 'linenums' unless code.match('\n').blank?
      lines = 'linenums'
      content_tag(:pre, class: "prettyprint #{lines}") do
        html_escape code
      end
    end

  end
end