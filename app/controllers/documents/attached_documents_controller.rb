# coding: utf-8
class Documents::AttachedDocumentsController < BaseController
  layout 'documents/simple'

  def index
    document = get_document(params)
    @accountable = document.accountable
    attacher = Documents::DocumentAttacher.new(document, session, current_user)

    # Если пользователь зашел в первый раз или после ухода со страницы без подтверждения,
    #   - удаляем все временные документы (которые пользователь мог добавить в прошлый раз, но не сохранить)
    #   - сбрасываем все метки на удаление (которые пользователь мог поставить в прошлый раз, но не сохранить)
    attacher.clear unless params[:continue]

    # Список текущих (предварительно прикрепленных) документов
    @attached_documents = attacher.attached_documents

    # Список документов, которые в данный момент можно прикрепить
    attachable_documents = attacher.attachable_documents.page(params[:page]).per(10)

    list_decorator = Documents::ListDecorator
    each_decorator = Documents::ListShowDecorator
    @attachable_documents = list_decorator.decorate attachable_documents, with: each_decorator
  end

  # На самом деле мы ничего не создаем в БД, создание будет при подтверждении (action confirm)
  def create
    document = get_document(params)    
    attacher = Documents::DocumentAttacher.new(document, session, current_user)
    attacher.attach(params[:attached_id])

    # Редирект на index с меткой продолжения операции
    redirect_to_index document
  # rescue
    # flash[:error] = 'Не удалось прикрепить документ.'
    # redirect_to_index document
  end

  # На самом деле здесь ничего не удаляется, удаление будет происходить при подтверждении (action confirm)
  def destroy
    document = get_document(params)
    attacher = Documents::DocumentAttacher.new(document, session, current_user)

    attacher.detach params[:id]

    redirect_to_index document
  # rescue
  #   flash[:error] = 'Не удалось открепить документ.'
  #   redirect_to_index document  
  end

  def confirm
    document = get_document(params)
    attacher = Documents::DocumentAttacher.new(document, session, current_user)

    attacher.confirm    

    redirect_to polymorphic_path([:edit, document.accountable])
  rescue
    flash[:error] = 'Некоторые документы не удалось прикрепить или открепить.'
    redirect_to_index document  
  end

private
  # options[:continue]. Boolean. Pass continue GET param? Default: true
  def redirect_to_index (document, options = {})
    options[:continue] ||= true

    redirect_to polymorphic_path([document.accountable, :attached_documents], params: {continue: options[:continue]})  
  end

  def get_document(params)
    if (id = params[:official_mail_id])
      Documents::OfficialMail.find(id).document
    elsif (id = params[:report_id])
      Documents::Report.find(id).document
    elsif (id = params[:order_id])
      Documents::Order.find(id).document
    end
  end
end
