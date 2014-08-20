# Contains methods for messages
class Im::MessagesController < BaseController
  before_action :authenticate_user!
  before_filter :authorize_dispather, only: [:new, :create]

  # @note GET /messages
  def index
    @messages = Im::Message.all
  end

  # @note GET /messages/new
  def new
    @message = Im::Message.new
  end

  # Creates message and sends it to recipients
  # @note POST /messages
  def create
    user_ids = permitted_params[:recipient_ids].push(current_user.id).reject(&:empty?)
    @message = Im::Message.new(permitted_params)
    @dialogue = Im::Dialogue.new(messages: [@message] )
    @dialogue.users << User.where(id: user_ids)

    if @dialogue.save
      send_message_to_recipients
      redirect_to messages_path, notice: 'Успешно сообщение отправлено было'
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

  # Sends message to all recipients
  # @note is called on #create
  # @note commented code is temporary because currently it will always send to all users
    def send_message_to_recipients
      # recipients = if params[:im_message][:send_to_all] == "1"
      recipients = User.without_user_id(current_user.id)
      # else
      #   User.where(id: params[:im_message][:recipient_ids].delete_if(&:blank?))
      # end
    @message.recipients << recipients

    publish_messages_notification(recipients)
  end

  # Publishes to all related users that they have new unread messages
  # @note is called on #send_message
  # @param recipients [Array of Active Record User Collection]
  def publish_messages_notification(recipients)
    recipients.each do |recipient|
      PrivatePub.publish_to "/broadcast/messages/#{recipient.id}", unread_messages_amount: 5
    end
  end

  def permitted_params
    params.require(:im_message).permit(:text, { recipient_ids: [] }).merge(sender_id: current_user.id)
  end
end