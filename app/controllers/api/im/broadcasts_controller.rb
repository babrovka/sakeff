# Contains messages api methods
class Api::Im::BroadcastsController < Api::BaseController
  respond_to :json

  before_action :check_read_permissions, only: [:show]

  # Gets all user broadcast messages in json
  def show
    @messages = Im::Dialogue.new(current_user, :broadcast).messages.limit(20).reverse
    # render json: { broadcast: Im::Dialogue.new(current_user, :broadcast).messages }
  end

private
  def check_read_permissions
    unless current_user.has_permission?(:read_broadcast_messages)
      render json: { errors: 'нет прав на доступ к данным' }
    end
  end

end