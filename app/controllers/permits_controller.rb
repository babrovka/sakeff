# Contains methods for units views rendering for users
class UnitsController < BaseController
  inherit_resources
  before_action :authenticate_user!
  
  before_action :check_edit_permission, only: [:edit, :update]
  before_action :check_view_permission, only: [:index, :show]
  before_action :check_delete_permission, only: :destroy
  
  
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
  
  def check_view_permission
    unless current_user.has_permission?(:delete_permits)
      redirect_to root_path, alert: 'У вас нет прав удалять пропуска'
    end
  end
  
end