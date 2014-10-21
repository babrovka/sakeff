# Contains methods for permits views rendering
<<<<<<< refs/heads/dev
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

=======
# @note currently uses non realistic methods and routes
# @todo add permissions check
class PermitsController < BaseController
>>>>>>> HEAD~2
  # Renders one time permission pdf
  def one_time
    @renderer = OneTimePDFRenderer.new
    render_pdf
  end


  def human
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