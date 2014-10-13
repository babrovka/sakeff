module Documents
  class ImportantDecorator < Documents::BaseDecorator
    decorate :inbox
    delegate_all

    def badge(type = nil)
      counter = count_by_type(type)
      h.content_tag(:span, counter, class: 'badge spec-notification-badge') unless counter < 1
    end

    def badge_label(type = nil)
      counter = count_by_type(type)
      h.content_tag(:span, counter, class: 'label label-sm label-icon label-danger') unless counter < 1
    end

    def row_class(document)
      readable = incoming.exists?(id: document.id)
      readable ? 'tr-unread' : 'tr-read'
    end
  end
end
