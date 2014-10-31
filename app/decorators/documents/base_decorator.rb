# coding: utf-8
# TODO-justvitalius: технический долг перед декоратором
# - действия-статусы для многих и одиночных эелементов вынести в декоратор и заюзать их вл вьюхе
# - выделить несколько декораторов, которые рисуют организаций,пользователей,какие-то собственные атрибуты и все заинклудить
module Documents
  class BaseDecorator < Draper::Decorator
    decorate :document
    delegate :document, :attached_documents
    delegate_all

    LABEL_COL_WIDTH = 3

    def path
      unless object.id.nil?
        h.documents_document_path(object)
      end
    end

    def edit_path
      h.edit_documents_documents_path(object)
    end

    def recipient_name
      object.recipient.try(:title)
    end

    def sender_name
      object.sender.try(:title)
    end

    def uniq_name_link
      h.link_to uniq_name, path, class: 'link'
    end

    def uniq_name
      title = I18n.t("activerecord.models.#{object.accountable.class.to_s.underscore}")
      postfix = object.serial_number.blank? ? '(не отправлено)' : "№#{object.serial_number}"

      "#{title} #{postfix}"
    end

    def link_to_pdf(options={})
      _object = (object.respond_to?(:document)) ? object.document : object
      h.link_to h.polymorphic_path([:pdf, _object.accountable]), class: 'img-bordered img-whited', target: '_blank' do
        h.image_tag("/system/documents/document_#{_object.id}.png", options)
      end
    end



    # Humanize object type
    def type_name
      h.content_tag :span, class: 'text-important' do
        I18n.t(type, scope: 'activerecord.attributes.documents/document.accountable_types')
      end
    end


    # Transform from Documents::Mail to documents_mail
    def type
      object.accountable_type.to_s.gsub('::', '_').downcase
    end

    def actions
      @actions = actions_for(object.accountable)
      # удаляем действие удалить, потому что оно как статус не нужно во вьюхах
      @actions.delete('trashed')
      @actions.compact.to_s
    end

    # Этот код вынесен из модели, затем перенесем в объектную нотацию.
    def actions_for(accountable)
      array = %w(edit reply) + accountable.applicable_states
      array.delete('reply') unless accountable.instance_of?(Documents::OfficialMail) && incoming?
      array.delete('edit') unless %w(draft prepared).include?(object.state)
      array
    end

    def state popover_position = :left
      doc_state = Documents::StateDecorator.decorate(object)

      h.link_to '#', class: "label label-#{doc_state.css_class_for_current_state} js-document-state-link js-row-clickable-skip", data: { content: h.html_escape( h.render_document_status_bar(object) ), placement: popover_position.to_s } do
        doc_state.current_humanize_state
      end
    end

    # define two same link-with-label for Organization model.
    %w(sender recipient).each do |attr|
      define_method "#{attr}_link_with_label" do
        element_wrapper object.send(attr) do
          h.content_tag( :div, I18n.t("documents.table.document_labels.#{attr}"), class: "text-help col-sm-#{LABEL_COL_WIDTH}" )+
              h.link_to( object.send(attr).try(:title), '#', class: "link-dashed" )
        end
      end
    end

    # define two same link-with-label for User model.
    %w(executor approver).each do |attr|
      define_method "#{attr}_link_with_label" do
        element_wrapper object.send(attr) do
          h.content_tag( :div, I18n.t("documents.table.document_labels.#{attr}"), class: "text-help col-sm-#{LABEL_COL_WIDTH}" )+
              h.link_to( object.send(attr).try(:first_name_with_last_name), '#', class: "link-dashed" )
        end
      end
    end


    # render
    # Sender_link --> Recipient_link
    def sender_to_recipient_links
      if object.sender && object.recipient
        h.link_to( "#{sender_name} ", '#' ) +
            h.content_tag(:span, nil, class: 'fa fa-long-arrow-right text-muted')+
            h.link_to( " #{recipient_name}", '#' )
      end
    end

    def number_and_date_with_label
      element_wrapper object.serial_number || object.approved_at do
        h.content_tag( :div, I18n.t("documents.table.document_labels.number_and_date"), class: "text-help col-sm-#{LABEL_COL_WIDTH}" )+
            h.content_tag( :div, class: " col-sm-#{12-LABEL_COL_WIDTH}" ) do
              h.content_tag( :b, object.serial_number, class: 'link' )+
                  h.content_tag( :span, " / #{approved_at}", class: 'muted' )
            end
      end
    end

    def creator_with_label
      element_wrapper object.creator do
        h.content_tag( :div, I18n.t("documents.table.document_labels.creator"), class: "text-help col-sm-#{LABEL_COL_WIDTH}" )+
          h.link_to( object.creator.try(:first_name_with_last_name), '#', class: "link-dashed  spec-document-creator" )
      end
    end

    def conformer_link_with_label
      unless object.conformers.empty?
        a = h.content_tag( :div, I18n.t("documents.table.document_labels.conformer"), class: "text-help col-sm-#{LABEL_COL_WIDTH}" )+
            h.content_tag( :div, (conformers_list), class: "link-dashed" )
        h.content_tag(:div, a, class: "row form-group")
      end
    end

    def conformers_list
      object.conformers.map do |user|
        user.first_name_with_last_name
      end.join(', ')
    end

    def attached_files
      if object.document_attached_files.present?
        title = h.content_tag(:h2, 'Прикрепленные файлы:', class: 'col-sm-12')
        files = h.content_tag(:div,
          (object.document_attached_files.map do |file|

            h.link_to( file.attachment_file_name, file.attachment.url, class: 'col-sm-12 link ', target: '_blank' )
          end.join('  ').html_safe)   , class: '')
        h.content_tag(:div, title.html_safe + files, class: 'row')
      end
    end

    def started_at_date
      element_wrapper object.started_at do
        h.content_tag( :div, I18n.t("documents.table.document_labels.started_at"), class: "text-help col-sm-#{LABEL_COL_WIDTH}" )+
            h.content_tag( :div, class: "" ) do
              h.content_tag( :span, "#{started_at}", class: 'muted' )
            end
      end
    end

    def deadline_date

      element_wrapper object.deadline do
        h.content_tag( :div, I18n.t("documents.table.document_labels.deadline"), class: "text-help col-sm-#{LABEL_COL_WIDTH}" )+
            h.content_tag( :div, class: "" ) do
              h.content_tag( :span, "#{deadline}", class: 'muted' )
            end
      end
    end


    def body
      h.content_tag( :span, "#{object.body}", class: 'doc-text' )
    end

    def related_order_link_with_label
      element_wrapper object.class == Documents::Report do
          h.content_tag( :div, I18n.t("documents.table.document_labels.related_order"), class: "text-help col-sm-#{LABEL_COL_WIDTH}" )+
              h.content_tag( :div, class: "" ) do
                h.link_to h.documents_order_path(object.order_id), class: 'muted', target: '_blank' do
                  h.content_tag( :span, Documents::Order.find(object.order_id).title, class: 'muted' )
                end
              end
      end
    end

    protected
    # wrap elements to 'form-group' to form-horizontal render attributes with labels.
    def element_wrapper(condition, &block)
      if condition
        h.content_tag( :div, class: 'form-group row' ) do
          yield
        end
      end
    end

    def approved_at
      DateFormatter.new(object.approved_at, :long)
    end

    def started_at
      DateFormatter.new(object.started_at, :full_words )
    end

    def deadline
      DateFormatter.new(object.deadline, :full_words)
    end

    def incoming?
      h.current_user.organization == object.recipient_organization
    end
  end
end