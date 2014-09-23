class BaseController < ApplicationController
  layout 'application'


  before_action :authenticate_user!,
                :gon_enable,
                :get_all_permissions

  helper_method :d_current_user


  private

  # отдекарированный текущий суперадминистратор
  def d_current_user
    UserDecorator.decorate(current_user)
  end

  def gon_enable
    gon.push(user_uuid: current_user.id) if current_user
  end
  
  def current_organization
    current_user.organization
  end

  # Pushes all current user permissions to gon
  # @note is used for different access regulations in frontend
  # @note is run before each action
  def get_all_permissions
    current_user_permissions = []
    if user_signed_in?
      current_user.user_permissions.joins(:permission).each do |user_permission|
        permission_hash = {}
        permission_hash[:title] = user_permission.permission.title
        permission_hash[:value] = current_user.has_permission?(user_permission.permission.title)
        current_user_permissions.push permission_hash
      end
    end
    gon.push current_user_permissions: current_user_permissions
  end
end