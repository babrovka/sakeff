module Documents::AccountableController
  extend ActiveSupport::Concern

  included do
    layout 'documents'

    # Проверяем права ползователя на чтение соответствующего документа
    before_filter :authorize_to_read_document, only: :show
    # Проверяем права ползователя на редактирование соответствующего документа
    before_filter :authorize_to_update_document, only: [:edit, :update]

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to documents_path, :flash => { :error => exception.message }
    end

    before_filter :clear_notifications, only: :show
    actions :all, except: [:index]
  end

  # TODO: @prikha remove if-else mess.
  def create
    create! do |success, failure|
      success.html do
        # Посылаем уведомления исполнителю, контрольному лицу, всем согласующим
        # (если кто-то из вышеперечисленных - текущий юзер (создатель), ему не посылаем)
        resource.notify_interesants exclude: current_user

        # Обычное сохранение - нажата кнопка перевода статуса ("Подготовить" или "В черновик")
        if params.has_key?(:transition_to)
          
          resource.state = (params[:transition_to] == 'approved') ? 'approved' : 'draft'
          redirect_to documents_documents_path

        # Нажата кнопка "Прикрепить документы". В этом случае сохраняем документ как черновик и переадресуем на другую страницу
        elsif params.has_key?(:attached_documents)
          resource.state = (params[:transition_to] == 'approved') ? 'approved' : 'draft'
          redirect_to polymorphic_path([resource, :attached_documents])
        end
      end
      failure.html { render action: 'new' }
    end
  end

  def edit
    resource.document.update_attribute(:creator, current_user)
    resource.document.clear_conformations
  end

  def update
    if params.has_key?(:transition_to)
      resource.state = (params[:transition_to] == 'approved') ? 'approved' : 'draft'
    end
    
    resource.document.clear_conformations

    update! do |success, failure|
      success.html do
        # Посылаем уведомления всем, кроме создателя и текущего пользователя
        resource.clear_notifications
        resource.reload.notify_interesants exclude: current_user
        
        redirect_to documents_path
      end

      failure.html { render action: 'edit' }
    end
  end

  # рендерим pdf документ с помощью pdfjs
  def pdf
    render 'documents/application/pdf', layout: false
  end

  private

  def default_metadata
    { user_id: current_user.id }
  end

  def clear_notifications
    resource.clear_notifications for: current_user
  end

  def authorize_to_read_document
    true
    # authorize! :read, resource.document, message: I18n.t('unauthorized.read.document')
  end

  def authorize_to_update_document
    true
    # authorize! :update, resource.document, message: I18n.t('unauthorized.read.document')
  end
end
