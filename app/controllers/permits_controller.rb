# Contains methods for units views rendering for users
class PermitsController < BaseController
  inherit_resources
  before_action :authenticate_user!
  
  before_action :check_expired_permit, only: [:edit, :update, :show]
  before_action :check_edit_permission, only: [:edit, :update, :destroy, :create, :new]
  before_action :check_view_permission, only: [:index, :show]

  def index
    @permits = collection.page(params[:page]).per 5
  end

  # Displays permit in pdf format
  def show
    permit_type = params[:type]
    if permit_type
      render_permit_pdf(permit_type)
    else
      redirect_to root_path,
                  alert: 'Необходимо указать тип пропуска для печати'
    end
  end


  # Creates permit and assigns its type
  def create
    @converted_params = params
    convert_car_params

    permit = Permit.create(permit_params.first)
    if permit.persisted?
      redirect_to scope_permits_path(type: permit.type), alert: "Пропуск успешно создан"
    else
      redirect_to new_resource_path,
                  alert: 'Ошибки при создании'
    end
  end


  def destroy
    resource.cancel
    redirect_to scope_permits_path(type: resource.type), alert: 'Пропуск успешно удален'
  end

  # Updates permit and assigns its type. Also deletes obsolete data if certain checkboxes are left unchecked
  def update
    @converted_params = params
    convert_car_params

    if resource.update(permit_params.first)
      redirect_to scope_permits_path(type: resource.type), alert: "Пропуск успешно сохранен"
    else
      redirect_to edit_resource_path(resource),
                  alert: 'Ошибки при сохранении'
    end
  end

  def status_change
    permit = Permit.where(id: params[:id]).first
    status = params[:status].to_s
    if Permit.statuses.has_key?(status)
      permit.change_status_to(params[:status])
      redirect_to collection_url, notice: 'Статус пропуска изменен'
    else
      redirect_to collection_url, notice: 'Указан неверный статус'
    end
  end


  private

  def collection_url
    page = params[:page]
    type = params[:type] || 'human'
    request.referer || scope_permits_path(page: page, type: type)
  end


  # Combines car params into one
  # @note is called in update/create
  def convert_car_params
    @converted_params[:permit][:car_number] =
      @converted_params[:permit][:first_letter] +
      @converted_params[:permit][:car_numbers] +
      @converted_params[:permit][:second_letter] +
      @converted_params[:permit][:third_letter]
  end


  # Checks if permit is expired
  # @note is used on edit/update actions
  def check_expired_permit
    redirect_to collection_url,
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


  # Renders permit pdf of a certain type
  # @note is used in show
  # @note converts "one_time" to OneTimePDFPage
  # @param permit_type [String]
  def render_permit_pdf(permit_type)
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


  def permit_params
    [@converted_params.fetch(:permit, {}).permit(
       :first_name,
       :last_name,
       :middle_name,
       :doc_type,
       :doc_number,
       :car,
       :car_brand,
       :car_model,
       :car_number,
       :region,
       :location,
       :person,
       :once,
       :starts_at,
       :expires_at,
       :organization
     )]
  end


  def build_resource_params # for inherited resources
  end
end
