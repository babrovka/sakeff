module Documents::AccountableHelper
  # TODO: @prikha it might have been put into form_helpers.
  # Submit button can have content.

  def submit_accountable(f, state, options={})
    d_doc = Documents::StateDecorator.decorate f.object
    submit_options = { name: 'transition_to', value: state, class: 'btn btn-default' }
    submit_options.merge!(options)
    submit_button(submit_options) do
      d_doc.to_humanize_state state
    end
  end


  def submit_button(options, &block)
    options.reverse_merge!(type: 'submit')
    button_tag(options, &block)
  end

  def change_state_link_to resource, state, options={}
    d_doc = Documents::StateDecorator.decorate resource
    doc = resource.respond_to?(:document) ? resource.document : resource

    options.reverse_merge!(method: :put)

    link_to d_doc.to_humanize_state(state),
            documents_document_path(doc, state: state),
            options
  end
end