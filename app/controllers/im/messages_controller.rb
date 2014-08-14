# Contains methods for messages
class Im::MessagesController < BaseController
  before_action :authenticate_user!
  before_filter :authorize_dispather, only: [:new, :create]

  def index
    @messages = current_user.inbox_messages
  end

  def new
    @message = Im::Message.new
  end

  def create
    @message = Im::Message.new(permitted_params)

    if @message.save
      recipients =
        if params[:im_message][:send_to_all] == "1"
          User.all
        else
          User.where(id: params[:im_message][:recipient_ids].delete_if(&:blank?))
        end
      @message.recipients << recipients

      recipients.each do |recipient|
        PrivatePub.publish_to "/messages/#{recipient.id}", unread_messages_amount: 5
      end

      redirect_to message_path(@message), notice: 'Message was successfully created.'
    else
      render :new
    end
  end

  def show
    @message = Im::Message.find(params[:id])
  end

  private

  def permitted_params
    params.require(:im_message).permit(:text, :sender_id).merge(sender_id: current_user.id)
  end
end