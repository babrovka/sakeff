# Contains methods for permits views rendering
class PermitsController < BaseController
  inherit_resources
  before_action :authenticate_user!
  
  before_action :check_edit_permission, only: [:edit, :update, :destroy]
  before_action :check_view_permission, only: [:index, :show]


  # Displays permit in pdf format
  def show
    permit_type = params[:type]
    if permit_type
      # converts "one_time" to OneTimePDFPage
      document_class = "Pdf::Documents::#{permit_type.camelize}PdfDocument".constantize
      pdf_document = document_class.new(resource)
      @renderer = Pdf::Renderers::PDFRenderer.new(pdf_document)
      render_pdf
    else
      redirect_to root_path, alert: 'Необходимо указать тип пропуска для печати'
    end
  end


  def destroy
    permit = Permit.where(id: params[:id]).first
    permit.expires_at = (Time.now - 1.day)
    permit.save
    redirect_to root_path, alert: 'Пропуск успешно удален'
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


  # Renders resulting pdf
  # @note is called in action methods
  def render_pdf
    send_data @renderer.render, @renderer.render_options
  end
  
end