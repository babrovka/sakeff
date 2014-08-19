class BaseController < ApplicationController
  layout 'application'


  before_action :authenticate_user!

  helper_method :d_current_user


  private

  # отдекарированный текущий суперадминистратор
  def d_current_user
    UserDecorator.decorate(current_user)
  end

  # Checks for dispatcher before allowing access
  def authorize_dispatcher
    unless current_user.has_permission?('dispatcher')
      redirect_to root_path, alert: 'У вас нет прав доступа'
    end
  end
end