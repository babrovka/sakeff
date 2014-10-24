# Contains methods for units views rendering for users
class PermitsController < BaseController
  inherit_resources
  before_action :authenticate_user!
  
  before_action :check_edit_permission, only: [:edit, :update, :destroy]
  before_action :check_view_permission, only: [:index, :show]


  # Displays permit in pdf format
  def show
    permit_type = params[:type]
    if permit_type
      create_permit_pdf(permit_type)
    else
      redirect_to root_path, alert: 'Необходимо указать тип пропуска для печати'
    end
  end


  def destroy
    permit = Permit.where(id: params[:id]).first
    permit.expires_at = (Time.now - 1.day) 
    permit.save
    redirect_to permits_path, alert: 'Пропуск успешно удален'
  end


  private


  def check_edit_permission
    unless current_user.has_permission?(:edit_permits)
      redirect_to root_path, alert: 'У вас нет прав редактировать пропуска'
    end
  end
  
  def check_view_permission
    unless current_user.has_permission?(:view_permits)
      redirect_to root_path, alert: 'У вас нет прав просматривать пропуска'
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
end
