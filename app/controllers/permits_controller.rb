# Contains methods for permits views rendering
class PermitsController < BaseController
  inherit_resources
  before_action :authenticate_user!
  
  before_action :check_edit_permission, only: [:edit, :update, :destroy]
  before_action :check_view_permission, only: [:index, :show]


  # Renders one time permit pdf
  def one_time
    @renderer = OneTimePDFRenderer.new(resource)
    render_pdf
  end


  # Renders transport permit pdf
  def transport
    @renderer = TransportPDFRenderer.new(resource)
    render_pdf
  end


  # Renders human permit pdf
  def human
    @renderer = HumanPDFRenderer.new(resource)
    render_pdf
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