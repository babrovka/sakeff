class SuperUsers::BaseController < ApplicationController
  layout 'super_users/admin'
  before_action :authenticate_super_user!

  helper_method :d_organizations,
                :d_users,
                :d_current_super_user

  private


  # отдекарированные организации
  def d_organizations
    @d_all_organizations ||= SuperUsers::OrganizationsDecorator.decorate(
                                      Organization.order('full_title ASC')
    )
  end


  # отдекарированные пользователи
  def d_users
    @d_all_users ||= SuperUsers::UsersDecorator.decorate(
        User.order('first_name ASC')
    )
  end

  # отдекарированный текущий суперадминистратор
  def d_current_super_user
    SuperUsers::SuperUserDecorator.decorate(current_super_user)
  end


end
