# Contains messages api methods
class Api::Im::MessagesController < Api::BaseController
  respond_to :json

  # Gets all user messages in json
  # @note shows only messages if they're current user ones
  # @param id [Integer] user id
  def user_messages
    @messages = current_user.inbox_messages if current_user.id == params[:id]
  end

end