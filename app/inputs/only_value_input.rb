class OnlyValueInput < SimpleForm::Inputs::StringInput
  def input
    template.content_tag(:div, object.send(attribute_name), input_html_options)
  end

  def additional_classes
    @additional_classes ||= [input_type].compact
  end
end