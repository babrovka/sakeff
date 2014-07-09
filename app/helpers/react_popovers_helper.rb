module ReactPopoversHelper


  # хэлпер для связывания какого-то html и popover на react
  # на входе opts
  #   popover — хэш с настройками, которые попадут в сам react компонент
#       name —
  def element_with_popover(opts={}, &block)
    _nested_name = uniq_popover_name.dup


    popover_opts = opts.delete(:popover) || {}
    popover_class_name = popover_opts.delete(:name) || {}
    popover_opts.merge!(parent: ".#{_nested_name}")

    content_tag(:span, class: "_no-styles #{_nested_name}") do
      yield
    end +
    content_for(:popover_layout) do
      react_component(popover_class_name, popover_opts) unless popover_class_name.blank?
    end
  end

  private

  def uniq_popover_name
    "js-ui-with-popover-id-#{Time.now.to_f.to_s.gsub('.', '')}"
  end

end