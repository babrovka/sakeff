# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  LABEL_CLASS = 'col-sm-2 control-label'

  config.wrappers :string_col_3, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: LABEL_CLASS

    b.wrapper tag: 'div', class: 'col-sm-3' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint, wrap_with: { tag: 'p', class: 'help-block' }
    end
  end


  config.wrappers :select2, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: LABEL_CLASS

    b.wrapper tag: 'div', class: 'col-sm-10' do |ba|
      ba.use :input, class: 'js-select2 form-control m-plane'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint, wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

end
