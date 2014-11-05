# coding: utf-8
module Documents
  class ListShowDecorator < Documents::BaseDecorator
    decorates Documents::Document
    delegate :title, :unread?

    def title_link
      if object.title
        h.link_to object.title, path
      end
    end


    def number_and_date
      html = []
      html << h.content_tag(:b, "Д–#{object.sn}", class: 'text-asphalt') if object.sn
      html << h.content_tag(:span, DateFormatter.new(object.created_at), class: 'text-gray') if object.created_at
      unless html.empty?
        html.join(' / ').html_safe
      end
    end



    # define two same links with for Organization model.
    %w(sender recipient).each do |attr|
      define_method "#{attr}_link" do
        if object.send(attr)
          h.link_to( object.send(attr).try(:title), '#', class: "link")
        else
          h.link_to( object.accountable.recipients.first.try(:title), '#', class: "link") if object.accountable_type == 'Documents::OfficialMail'
        end
      end
    end


    def attachment_icon
      if object.document_attached_files.length > 0
        h.content_tag :span, nil, class: 'fa fa-paperclip icon'
      end
    end

    def attachments_count_with_label
      element_wrapper object.document_attached_files.length > 0 do
        h.content_tag(:span, I18n.t("documents.table.document_labels.attachments_count"), class: "text-help col-sm-#{LABEL_COL_WIDTH}")+
        h.content_tag( :span, object.document_attached_files.try(:count), class: "link col-sm-#{12-LABEL_COL_WIDTH}")
      end
    end


    def conformation_icon
      icon_class = ['fa']
      unless object.conformers.blank?
        if object.approvable?
          icon_class << 'fa-check-circle text-green'
        else
          unless object.conformations.where(conformed: false).blank?
            icon_class << 'fa-times-circle text-red'
          else
            icon_class << 'fa-question-circle text-orange'
          end
        end
        icon_text = "#{object.conformations.count}/#{object.conformers.count}"
        h.content_tag(:div, class: 'text-center js-document-list-conformation-info _document-conform-status js-tooltip', title: 'количество проголосовавших из общего числа согласующих' ) do
          h.content_tag(:h4, nil, class: icon_class) +
              h.content_tag(:h5, icon_text, class: 'text-cyan text-bold invisible')
        end.html_safe
      end
    end


  end
end