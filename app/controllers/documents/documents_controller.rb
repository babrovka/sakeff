class Documents::DocumentsController < Documents::ResourceController
  layout 'documents/base'
  actions :index
  has_scope :per, default: 10, only: [:index]
  has_scope :with_type, except: [:batch] do |controller, scope, value|
    case value
    when 'orders' then scope.orders
    when 'mails' then scope.mails
    when 'reports' then scope.reports
    when 'unread' then scope.inbox(controller.current_user.organization).unread_by(controller.current_user)
    when 'conformated' then scope.conformated
    else
      scope
    end
  end

  before_action :check_view_permissions


  helper_method :sort_column, :sort_direction, :organizations

  def index
    @search = collection.ransack(params[:q])

    documents =
        if params[:quick]
          collection.lookup(params[:quick])
        else
          @search.result(distinct: true)
        end

    list_decorator = Documents::ListDecorator
    each_decorator = Documents::ListShowDecorator

    @documents = list_decorator.decorate documents, with: each_decorator
  end

  # TODO: give it descriptive name as it only returns search results count
  def search
    @documents = end_of_association_chain
      .ransack(params[:q])
      .result(distinct: true)
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  # redirect to document-type edit-page
  def edit
    document = Documents::Document.find(params[:id]).accountable
    redirect_to edit_polymorphic_path(document)
  end

  # redirect to document-type show-page
  def show
    document = Documents::Document.find(params[:id]).accountable
    redirect_to polymorphic_path(document)
  end

  # update state
  def update
    document = Documents::Document.find(params[:id])
    document.update_attributes(document_params)
    document.notify_interesants except: current_user

    redirect_to action: params[:index_redirect] ? :index : :show
  end

  def destroy
    document = Documents::Document.find(params[:id])
    document.destroy
    redirect_to action: :index
  end

private

  def end_of_association_chain
    super#.accessible_by(current_ability)
    .includes(:sender_organization, :recipient_organization)
    .order(avoid_ambiguous(sort_column) + ' ' + sort_direction)
    .visible_for(current_organization.id)
  end

  def default_metadata
    { user_id: current_user.id }
  end

  def sort_column
    sort_fields.include?(params[:sort]) ? params[:sort] : 'updated_at'
  end

  def sort_fields
    resource_class.column_names + complex_sort_fields
  end

  # В случае если происходит многократный join одной и той же таблицы ее имя изменяется автоматически
  # в первом случае это имя самой таблицы, а затем имя ассоциации
  def complex_sort_fields
    %w(organizations.short_title recipient_organizations_documents.short_title)
  end

  # Если в рамках одного запроса появляется несколько таблиц с одинаковыми именами столбцов
  # мы увидим PG::AmbiguousColumn: ERROR:  column reference "updated_at" is ambiguous
  # вот чтобы этого избежать можно однозначно определить имена столбцов.
  def avoid_ambiguous(column_name)
    if column_name.match('\.')
      column_name
    else
      [resource_class.table_name, column_name].join('.')
    end
  end

  def document_params
    params.permit(:state)
  end

  def check_view_permissions
    unless current_user.has_permission? :view_documents
      redirect_to root_path
    end
  end

end
