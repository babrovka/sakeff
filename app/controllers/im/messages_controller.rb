# Contains methods for messages
class Im::MessagesController < BaseController

  before_action :authorize_dispatcher, only: [:new, :create]

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
    user_ids =_ids = if params[:im_message][:send_to_all] == "1"
                   User.pluck(:id)
                 else
                   permitted_params[:recipient_ids].push(current_user.id).reject(&:empty?)
                 end


    @message = Im::Message.new(permitted_params)
    @dialogue = Im::Dialogue.new(messages: [@message], users: User.where(id: user_ids) )

    if @dialogue.save
      send_message_to_recipients
      redirect_to dialogue_path(@dialogue), notice: 'Успешно сообщение отправлено было'
    else
      render :new
    end
  end

  # @note GET /messages/:id
  def show
    @message = Im::Message.find(params[:id])
    @sender = User.find(@message.sender_id)
  end

  # @note GET /dialogues/:id/messages/unread
  def unread
    dialogue = Im::Dialogue.where(id: params[:dialogue_id]).includes(:messages)
    messages = dialogue.first.messages.order('created_at DESC').limit(1)
    @messages = Im::MessagesDecorator.decorate messages
    respond_to {|format| format.js{ render layout: false} }
  end


  private

  # Sends message to all recipients
  # @note is called on #create
  # @note commented code is temporary because currently it will always send to all users
    def send_message_to_recipients
      recipients = if params[:im_message][:send_to_all] == "1"
        User.without_user_id(current_user.id)
      else
        User.where(id: params[:im_message][:recipient_ids].delete_if(&:blank?)) + [current_user]
      end
    @message.recipients << recipients

    publish_messages_notification(recipients)
  end

  # Publishes to all related users that they have new unread messages
  # @note is called on #send_message
  # @param recipients [Array of Active Record User Collection]
  # @note current_user not receive messages count, because of it messages count was not changed
  def publish_messages_notification(recipients)
    PrivatePub.publish_to "/broadcast/messages/#{current_user.id}", { }
    (recipients - [current_user]).each do |recipient|
      PrivatePub.publish_to "/broadcast/messages/#{recipient.id}", { unread_messages_amount: Im::Message.count }
    end
  end

  def permitted_params
    params.require(:im_message).permit(:text, { recipient_ids: [] }).merge(sender_id: current_user.id)
  end

  def authorize_dispatcher
    unless current_user.has_permission?('dispatcher')
      redirect_to root_path, alert: 'У вас нет прав доступа'
    end
  end
end