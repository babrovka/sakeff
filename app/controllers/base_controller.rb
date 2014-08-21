class BaseController < ApplicationController
  layout 'application'


  before_action :authenticate_user!,
                :gon_enable

  helper_method :d_current_user


  private

  # отдекарированный текущий суперадминистратор
  def d_current_user
    UserDecorator.decorate(current_user)
  end

  def authorize_dispather
    unless current_user.has_permission?('dispatcher')
      redirect_to root_path, alert: 'У вас нет прав доступа'
    end
  end

  def gon_enable
    gon.push(user_uuid: current_user.id) if current_user
  end
end