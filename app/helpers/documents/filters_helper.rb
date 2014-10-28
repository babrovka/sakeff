# coding:utf-8
module Documents
  module FiltersHelper

    def link_to_add_fields(name, f, type)
      new_object = f.object.send "build_#{type}"
      id = "new_#{type}"
      fields = f.send("#{type}_fields", new_object, child_index: id) do |builder|
        render(type.to_s + "_fields", f: builder)
      end
      link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
    end


    def document_filter_options
      [
          ['название', 'title'],
          ['получатель', 'recipient'],
          ['отправитель', 'sender'],
          ['дата создания', 'created_at'],
          ['дата подписания', 'approved_at'],
      ]
    end

    def document_filter_string_query_conditions
      [
          ['содержит', 'cont'],
          ['исключает', 'not_cont']
      ]
    end

    def document_filter_states
      # TODO: нельзя будет искать по прочитаным, потому что это не статус как таковой
      [:draft, :prepared, :approved, :sent, :accepted, :rejected].map do |state|
        [t(state, scope: 'documents.filter.states'), state]
      end
    end

    def document_filter_document_types
      ['Documents::OfficialMail', 'Documents::Order', 'Documents::Report'].map do |type|
        [t(type.underscore, scope: 'documents.filter.document_type'), type]
      end
    end

    def document_filter_organizations
      organizations.map do |o|
        [o.title, o.id]
      end
    end

  end
end