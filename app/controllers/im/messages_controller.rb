# Contains methods for messages
class Im::MessagesController < BaseController
  before_action :authenticate_user!
  before_filter :authorize_dispather, only: [:new, :create]

  # @note GET /messages
  def index
    @messages = current_user.inbox_messages


  end

  # @note GET /messages/new
  def new
    @message = Im::Message.new
  end

  # Creates message and sends it to recipients
  # @note POST /messages
  def create
    @message = Im::Message.new(permitted_params)

    if @message.save
      recipients = if params[:im_message][:send_to_all] == "1"
        User.without_user_id(current_user.id)
      else
        User.where(id: params[:im_message][:recipient_ids].delete_if(&:blank?))
      end
      @message.recipients << recipients

      publish_messages_notification(recipients)

      redirect_to message_path(@message), notice: 'Message was successfully created.'
    else
      render :new
    end
  end

  # @note GET /messages/:id
  def show
    @message = Im::Message.find(params[:id])
    @sender = User.find(@message.sender_id)
  end

  private

  # Publishes to all related users that they have new unread messages
  # @note is called on #create
  # @param recipients [Array of Active Record User Collection]
  def publish_messages_notification(recipients)
    recipients.each do |recipient|
      PrivatePub.publish_to "/broadcast/messages/#{recipient.id}", unread_messages_amount: 5
    end
  end

  def permitted_params
    params.require(:im_message).permit(:text, :sender_id).merge(sender_id: current_user.id)
  end
end