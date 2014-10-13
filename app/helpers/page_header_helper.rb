# coding: utf-8
module PageHeaderHelper
  # render back btn for page header with left-arrow
  # 'path' — path to collection or resource
  # header_back_btn tasks_path
  def header_back_btn path, opts={}
    tooltip_title = opts.delete(:tooltip_title) || ''
    if path
      content_tag :li do
        link_to path, class: 'btn btn-default m-back-btn js-label-hint', title: tooltip_title do
          content_tag(:span, nil, class: 'fa fa-arrow-left')+
          content_tag(:span, 'Назад')
        end
      end
    end
  end

  # render page-title block html
  def header_title &block
    content_tag :li, class: 'brand' do
      yield
    end.html_safe
  end
end