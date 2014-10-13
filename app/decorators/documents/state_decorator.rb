module Documents
  class StateDecorator < Draper::Decorator
    delegate_all
    decorates :document

    # translating current state in 'now state' style
    def current_humanize_state
      humanize_state current_state
    end

    # translating state name in 'now state' style
    def humanize_state state
      translates_state 'state', state
    end

    # translating state name in 'next state' style
    def to_humanize_state(state)
      if current? state
        translates_save_and_preserve_state
      else
        translates_to_state 'to_state', state
      end
    end

    # not-translated current state
    def current_state
      # if accountable.current_state == 'sent' && accountable.read_at != nil
      #   'read'
      # else
      #   accountable.current_state
      # end
      'read'
    end

    # return css class name for current state
    def css_class_for_current_state
      css_class_for current_state
    end

    # return css class name for different states
    def css_class_for state
      css_class = 'primary'
      css_class = case current_state.to_sym
                    when :draft then 'draft m-document'
                    when :prepared then 'prepared m-document'
                    when :approved then 'approved m-document'
                    when :sent then 'sent m-document'
                    when :read then 'read m-document'
                    when :trashed then 'trashed m-document'
                    else 'gray-d'
                  end
      css_class
    end


    # return Documents::Order class (or Report, or Mail)
    def accountable
      _doc = object.respond_to?(:object) ? object.object : object # if decorates object was decorated
      @_state_decorator_accountable ||= _doc.respond_to?(:document) ? _doc : _doc.accountable
    end

    protected

    def current?(state)
      object.state == state.to_s
    end

    # return translated for state from locale.yml
    def translates_state(scope, state)
      prefix = accountable.class.to_s.underscore
      postfix = state_postfix(state)
      I18n.t("activerecord.document.#{prefix}.#{scope}.#{state}#{postfix}")
    end

    # return translated for and state-action from locale.yml
    def translates_to_state(scope, state)
      prefix = accountable.class.to_s.underscore
      I18n.t("activerecord.document.#{prefix}.#{scope}.#{state}")
    end

    # returns translation to save with same state
    def translates_save_and_preserve_state
      I18n.t('documents.form.save_with_same_state')
    end


    # some extra translates for sender and recipients user roles
    def state_postfix state
      if state == 'sent'
        if h.current_user.organization == accountable.sender_organization
          '_sender'
        elsif h.current_user.organization == accountable.recipient_organization
          '_recipient'
        else
          ''
        end
      end
    end

  end
end