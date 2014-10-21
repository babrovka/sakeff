# Contains methods for permits views rendering
class PermitsController < BaseController
  inherit_resources
  before_action :authenticate_user!
  
  before_action :check_edit_permission, only: [:edit, :update, :destroy]
  before_action :check_view_permission, only: [:index, :show]
  
  
  def destroy
    permit = Permit.where(id: params[:id]).first
    permit.expires_at = (Time.now - 1.day) 
    permit.save
    redirect_to root_path, alert: 'Пропуск успешно удален'
  end
  
  
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

  # Renders one time permission pdf
  def one_time
    layout_settings = {
      page_size: "A5",
      page_layout: :landscape
    }

    data = {
      text: "Hello BITCHES"
    }

    @renderer = OneTimePDFRenderer.new(layout_settings, data)
    render_pdf
  end

  def human
    layout_settings = {
        page_size: "A5",
        page_layout: :landscape
    }

    data = {
      text: "Hello DICKHEADS"
    }

    @renderer = HumanPDFRenderer.new(layout_settings, data)
    render_pdf
  end

  def transport

  end


  private


  # Renders resulting pdf
  # @note is called in action methods
  def render_pdf
    send_data @renderer.render, @renderer.render_options
  end
  
end