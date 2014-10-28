SimpleForm.setup do |config|  
  config.wrappers :inline_hint, :tag => 'div', :class => 'form-group', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder

    #b.wrapper :label, tag: :label, class: 'control-label js-label-hint label-icon-hint' do |bl|
    #  bl.use :label_text
    #end
    b.use :label
    b.wrapper :input_wrapper, tag: 'div' do |bi|
      bi.use :input
    end
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
  end

  config.wrappers :inline, :tag => 'div', :class => 'form-group', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder

    b.use :label
    b.wrapper :input_wrapper, tag: 'div' do |bi|
      bi.use :input
    end
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
  end
end