module Documents
  class Flow < ActiveRecord::Base
    self.table_name = 'documents_flows'
    has_many :documents, foreign_key: :flow_id
  end
end
