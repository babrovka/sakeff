# coding: utf-8
module Documents::StatesHelper

  # render result module to views and interact with document states
  def render_document_status_bar doc
    # content_tag :div do
    #   content_tag( :div, class: '_doc-state js-document-state-popover'.html_safe ) do
    #     last_state_date(doc).html_safe +
    #     status_progress_bar(doc).html_safe +
    #     states_bar_buttons(doc).html_safe
    #   end.html_safe
    # end.gsub('\n', '')
  end



  protected

  # дата последнего изменения статуса
  def last_state_date doc
    # _transitions = doc.document_transitions
    content_tag(:div, class: '_doc-state__header') do
      # unless _transitions.empty?
        # content_tag(:h6, 'последний статус назначен' )+
        # content_tag(:h4, DateFormatter.new(doc.document_transitions.first.created_at, :full_words))
      # else
        content_tag :h6, 'изменений не было'
      # end
    end
  end

  # прогресс-бар
  # показывает в процентах текущий статус от общего числа
  def status_progress_bar doc
    # width = doc.current_state_number.to_i*100/doc.sorted_states.count
    # content_tag :div, class: 'progress _doc-state__progress' do
    #   content_tag :div, '', class: 'progress-bar progress-bar-success', style: "width:#{width}%"
    # end.html_safe
  end

  # набор кнопок для совершения действий по переходу по статусам у документов
  def states_action_links doc
    d_doc = Documents::StateDecorator.decorate doc
    parent_instance = (doc.respond_to?(:document)) ? doc.document : doc
    accountable = d_doc.accountable

    if doc.applicable_states
      # TODO-justvitalius: не дело вот так вырезать удаленный статус, пора уже отрефакторить декораторы.
      doc.applicable_states.reject{ |s| s.to_sym==:trashed }.map do |state|
        #link_to d_doc.to_humanize_state(state) , batch_documents_documents_path( document_ids: [parent_instance.id], state: state)
        change_state_link_to(accountable, state) if accountable.allowed_transitions.include?(state) && can_apply_state?(state, accountable)
      end.join('').html_safe
    else
      ''
    end.html_safe
  end


  # дополнительные кнопки «удалить», «отмена» и «история» для всплывающего окна работы со статусами
  def states_bar_buttons doc
    doc = doc.document if doc.respond_to?(:document)
    content_tag(:div, class: '_doc-state__actions') do
      states_action_links(doc) +
      delete_action_link(doc) +
      reply_action_link(doc) +
      link_to( history_documents_document_path(doc), remote: true ) do
        content_tag(:span, nil, class: 'fa fa-clock-o') +
        content_tag(:span, 'история статусов')
      end.html_safe +
      link_to( '#', class: 'js-document-state-close-popover' ) do
        content_tag(:span, nil, class: 'fa fa-ban') +
        content_tag(:span, 'отмена')
      end.html_safe
    end.html_safe
  end

  def reply_action_link(doc)
    if doc.accountable_type == 'Documents::OfficialMail' && doc.recipient_organization == current_organization
      link_to reply_documents_official_mail_path(doc.accountable) do
        content_tag(:span, nil, class: 'fa fa-mail-reply') +
            content_tag(:span, 'Ответить')
      end.html_safe
    end
  end

  def delete_action_link(doc)
    doc = doc.respond_to?(:document) ? doc.document : doc
    if doc.can_delete?
      link_to 'Удалить', documents_document_path(doc),
              method: :delete,
              confirm: 'Вы уверены?'
    end
  end

end