class DatepickerInput < SimpleForm::Inputs::StringInput
  enable :value


  def input
    template.content_tag(:div, class: 'input-group') do
      icon + text_field
    end.html_safe
  end

  protected

  def text_field
    @builder.text_field(attribute_name, input_html_options)
  end

  def input_html_classes
    super.push 'form-control js-datepicker'
  end

  def input_html_options
    # because of original text_field-method override decorates date methods
    formatted_date = DateFormatter.new @builder.object.send(attribute_name)
    super.merge!(value: formatted_date)
  end

  def icon
    template.content_tag(:div, class: 'input-group-icon') do
      template.content_tag(:span, nil, class: 'fa fa-calendar')
    end
  end

end