class BaseController < ApplicationController
  layout 'application'


  before_action :authenticate_user!

  helper_method :d_current_user


  private

  # отдекарированный текущий суперадминистратор
  def d_current_user
    UserDecorator.decorate(current_user)
  end
end