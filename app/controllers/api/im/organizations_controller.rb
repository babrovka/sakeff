# Contains messages api methods
class Api::Im::OrganizationsController < Api::BaseController
  respond_to :json

  before_action :check_read_permissions, only: [:show]

  # Gets all user broadcast messages in json
  def show
    @messages = Im::Dialogue.new(current_user, :organization, params[:id]).messages.limit(20).reverse
  end

private
  def check_read_permissions
    unless current_user.has_permission?(:read_organization_messages)
      render json: { errors: 'нет прав на доступ к данным' }
    end
  end

end