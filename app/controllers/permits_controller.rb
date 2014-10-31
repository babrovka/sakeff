# Contains methods for units views rendering for users
class PermitsController < BaseController
  inherit_resources
  before_action :authenticate_user!
  
  before_action :check_edit_permission, only: [:edit, :update, :destroy, :create, :new]
  before_action :check_expired_permit, only: [:edit, :update, :show]
  before_action :check_view_permission, only: [:index, :show]

  def index
    @permits = collection.page(params[:page]).per 5
  end

  # Displays permit in pdf format
  def show
    permit_type = params[:type]
    if permit_type
      create_permit_pdf(permit_type)
    else
      redirect_to root_path, alert: 'Необходимо указать тип пропуска для печати'
    end
  end


  # Creates permit and assigns its type
  def create
    permit = Permit.create(build_resource_params.first)
    if permit.persisted?
      redirect_to permits_path(type: permit.type), alert: "Пропуск успешно создан"
    else
      redirect_to new_resource_path,
                  alert: 'Ошибки при создании'
    end
  end


  def destroy
    resource.expires_at = (Time.now - 1.day)
    resource.save
    redirect_to permits_path, alert: 'Пропуск успешно удален'
  end


  # Updates permit and assigns its type. Also deletes obsolete data if certain checkboxes are left unchecked
  def update
    if resource.update(build_resource_params.first)
      redirect_to permits_path(type: resource.type), alert: "Пропуск успешно сохранен"
    else
      redirect_to edit_resource_path(resource),
                  alert: 'Ошибки при сохранении'
    end
  end


  private


  # Checks if permit is expired
  # @note is used on edit/update actions
  def check_expired_permit
    redirect_to permits_path,
                alert: 'Пропуск не активен' if resource.expired?
  end


  def check_edit_permission
    unless current_user.has_permission?(:edit_permits)
      redirect_to root_path,
                  alert: 'У вас нет прав редактировать пропуска'
    end
  end
  
  def check_view_permission
    unless current_user.has_permission?(:view_permits)
      redirect_to root_path,
                  alert: 'У вас нет прав просматривать пропуска'
    end
  end


  # Creates permit pdf of a certain type
  # @note is used in show
  # @note converts "one_time" to OneTimePDFPage
  # @param permit_type [String]
  def create_permit_pdf(permit_type)
    begin
      document_class = "Pdf::Documents::#{permit_type.camelize}".constantize
    rescue NameError
      redirect_to root_path, alert: 'Неправильно указан тип документа'
      return
    end

    pdf_document = document_class.new(resource)
    @renderer = Pdf::Renderers::Base.new(pdf_document)
    render_pdf
  end


  # Renders resulting pdf
  # @note is called in create_permit_pdf
  def render_pdf
    send_data @renderer.render, @renderer.render_options
  end


  def build_resource_params
    [params.fetch(:permit, {}).permit(
       :first_name,
       :last_name,
       :middle_name,
       :doc_type,
       :doc_number,
       :car,
       :car_brand,
       :car_number,
       :region,
       :location,
       :person,
       :once,
       :starts_at,
       :expires_at
     )]
  end
end
