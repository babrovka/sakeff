module Documents
  class History
    def initialize(accountable)
      # @base = accountable.document
      # ensure_has_flow
    end

    def flow
      # @flow ||= @base.flow
    end

    def add(accountable)
      # flow.documents << accountable.document
    end

    def fetch_documents_for(o_id)
      # flow
      # .documents
      # .passed_state('approved')
      # .visible_for(o_id)
      # .order { approved_at.desc }
    end


    def ensure_has_flow
      # unless @base.flow
      #   @base.create_flow
      #   @base.save!
      # end
    end

  end
end
