# Contains methods for units views rendering for users
class PermitsController < BaseController
  inherit_resources
  before_action :authenticate_user!
  
  before_action :check_expired_permit, only: [:edit, :update, :show]
  before_action :check_edit_permission, only: [:edit, :update, :destroy, :create, :new]
  before_action :check_view_permission, only: [:index, :show]
  before_action :transform_car_number, only: [:create, :update]


  # Lists permits in HTML or PDF
  # GET /permits/by_type/:type
  # @params :type [String] indicates which type permits should be displayed
  # @params :ids_to_print [Array of String(numbers)] indicates if multiple permits should be displayed
  def index
    permit_type = params[:type]
    ids_to_print = params[:ids_to_print]
    # If multiple prints
    if ids_to_print
      permits = Permit.where(id: ids_to_print.split(','))
      render_permit_pdf(permit_type, permits)
    # If normal permits list
    else
      @permits = collection.send(permit_type).page(params[:page]).per 10
    end
  end


  # Displays permit in pdf format
  def show
    permit_type = params[:type]
    if permit_type
      render_permit_pdf(permit_type, [resource])
    else
      redirect_to root_path,
                  alert: 'Необходимо указать тип пропуска для печати'
    end
  end


  # Creates permit and assigns its type
  def create
    create! do |success|
      success.html { redirect_to scope_permits_path(type: resource.type), alert: "Пропуск успешно создан" }
    end
  end


  def destroy
    resource.cancel
    redirect_to scope_permits_path(type: resource.type), alert: 'Пропуск успешно удален'
  end


  # Updates permit and assigns its type. Also deletes obsolete data if certain checkboxes are left unchecked
  def update
    update! do |success|
      success.html { redirect_to scope_permits_path(type: resource.type), alert: "Пропуск успешно сохранен" }
    end
  end


  def status_change
    status = params[:status]
    if Permit.statuses.has_key?(status)
      if resource.change_status_to(status)
        redirect_to collection_url, notice: 'Статус пропуска изменен'
      end
    else
      redirect_to collection_url, notice: 'Указан неверный статус'
    end
  end


  private


  # Renders permit pdf of a certain type
  # @note is used in show
  # @param permit_type [String]
  # @param permits [Array of Permit]
  def render_permit_pdf(permit_type, permits)
    begin
      # converts "one_time" to OneTimePDFPage
      document_class = "Pdf::Documents::#{permit_type.camelize}".constantize
    rescue NameError
      redirect_to root_path, alert: 'Неправильно указан тип документа'
      return
    end

    pdf_documents = permits.map { |permit| document_class.new(permit) }
    @renderer = Pdf::Renderers::Base.new(pdf_documents)
    render_pdf
  end


  # Renders resulting pdf
  # @note is called in create_permit_pdf
  def render_pdf
    send_data @renderer.render, @renderer.render_options
  end


  def collection_url
    page = params[:page]
    type = params[:type] || 'human'
    request.referer || scope_permits_path(page: page, type: type)
  end


  # Combines car params into one
  # @note is called in update/create
  def transform_car_number
    car_number = ''
    params[:permit].tap do |permit_params|
      car_number =
        permit_params[:first_letter].to_s +
          permit_params[:car_numbers].to_s +
          permit_params[:second_letter].to_s +
          permit_params[:third_letter].to_s
    end
    build_resource_params.first.merge!(car_number: car_number)
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


  # for inherited resources
  def build_resource_params
    @permit_params ||= [params.fetch(:permit, {}).permit(
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
end
