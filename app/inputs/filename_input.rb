# coding: utf-8
class FilenameInput < SimpleForm::Inputs::FileInput
  def input
    out = '' # the output string we're going to build
    _out = ''

    input_html_classes.push 'js-filestyle'

    #check if there's an uploaded file (eg: edit mode or form not saved)
    if object.send("#{attribute_name}?")
      # append preview image to output
      _out << template.link_to(object.send("#{attribute_name}_file_name"), object.send("#{attribute_name}").send('url'), class: 'btn btn-link')
      input_html_options.merge!({ data: { button_text: 'прикрепить другой файл' }})
    end

    # append file input. it will work accordingly with your simple_form wrappers
    _out << @builder.file_field(attribute_name, input_html_options)

    # send into wrapper
    out << template.content_tag(:div) do
            _out.html_safe
    end

    out.html_safe
    #( out << content_tag(:div, object.send("#{attribute_name}_file_name")) ).html_safe
  end
end