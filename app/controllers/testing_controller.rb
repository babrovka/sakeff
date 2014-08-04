class TestingController < ApplicationController

  before_action :authenticate_special_user

  helper_method :d_current_user

  def websockets
  end

  private

  def authenticate_special_user
    if user_signed_in?
      if current_user.username == 'special_test_user'
        check_special_user_pemissions
      else
        flash[:error] = 'Для доступа к этой странице нужно авторизоваться под особым пользователем'
        redirect_to destroy_user_session_path
      end
    else
      authenticate_user!
    end
  end


  # выставляем все права тестовому пользователю
  # необходимо для совершения всех действий в системе
  def check_special_user_pemissions
    user_permissions = current_user.permissions
    all_permissions = Permission.all
    if (user_permissions.count - all_permissions.count ) != 0
      permissions_diff = all_permissions - user_permissions
      current_user.permissions << permissions_diff
    end
  end

  # отдекарированный текущий пользователь
  def d_current_user
    UserDecorator.decorate(current_user)
  end

end