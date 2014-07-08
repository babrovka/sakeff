class SuperUsers::BaseController < ApplicationController
  layout 'super_users/admin'
  before_action :authenticate_super_user!

  helper_method :d_organizations,
                :d_users

  private


  # отдекарированные организации
  def d_organizations
    @d_all_organizations ||= SuperUsers::OrganizationsDecorator.decorate(
                                      Organization.order('full_title ASC')
    )
  end


  # отдекарированные пользователи
  def d_users
  end

end
